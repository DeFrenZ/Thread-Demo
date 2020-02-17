import Combine
import Foundation

/// An object managing the data of multiple stores. It provides access to higher level operations, and keeps the data in sync.
final class DataStore<S: Scheduler>: ObservableObject {
	@Published private(set) var posts: StoreData<[Post.Connected]> = .init()
	@Published private(set) var users: StoreData<[User.Connected]> = .init()
	@Published private(set) var comments: StoreData<[Comment.Connected]> = .init()

	private let postsStore: PostsStore<S>
	private let usersStore: UsersStore<S>
	private let commentsStore: CommentsStore<S>
	private var cancellable: AnyCancellable?

	init(
		postsStore: PostsStore<S>,
		usersStore: UsersStore<S>,
		commentsStore: CommentsStore<S>
	) {
		self.postsStore = postsStore
		self.usersStore = usersStore
		self.commentsStore = commentsStore

		bindToChildrenStores()
	}

	private func bindToChildrenStores() {
		(self.posts, self.users, self.comments) = postsStore.posts.connectedTo(
			users: usersStore.users,
			comments: commentsStore.comments
		)

		self.cancellable = postsStore.$posts
			.combineLatest(usersStore.$users, commentsStore.$comments)
			.removeDuplicates(by: ==)
			.map({ $0.connectedTo(users: $1, comments: $2) })
			.logOutputs(.info, on: logger)
			.sink(receiveValue: { [weak self] posts, users, comments in
				guard let self = self else { return }
				setIfUnequal(&self.posts, to: posts)
				setIfUnequal(&self.users, to: users)
				setIfUnequal(&self.comments, to: comments)
			})
	}
}

extension DataStore {
	func fetchAll(_ fetchType: FetchType = .remoteFirst(forced: false)) {
		logger.info("Fetching: \(public: String(describing: fetchType))")
		postsStore.fetch(fetchType)
		// ???: Consider not fetching the rest until a post detail is shown, but the list looks better with the additional data
		usersStore.fetch(fetchType)
		commentsStore.fetch(fetchType)
	}
}

extension RemoteData where Data == [Post] {
	func connectedTo(
		users: RemoteData<[User], Failure>,
		comments: RemoteData<[Comment], Failure>
	) -> (
		posts: RemoteData<[Post.Connected], Failure>,
		users: RemoteData<[User.Connected], Failure>,
		comments: RemoteData<[Comment.Connected], Failure>
	) {
		let basePosts = map({ $0.map({ Post.Connected(post: $0) }) })
		let baseUsers = users.map({ $0.map({ User.Connected(user: $0) }) })
		let baseComments = comments.map({ $0.map({ Comment.Connected(comment: $0) }) })

		let connectedPosts: RemoteData<[Post.Connected], Failure> = basePosts.map({ base in
			let withUsers = (baseUsers.lastValidData?.data)
				.map({ base.connectedTo(users: $0).posts })
				?? base
			let connected = (baseComments.lastValidData?.data)
				.map({ $0.connectedTo(posts: withUsers).posts })
				?? withUsers
			return connected
		})

		let connectedUsers: RemoteData<[User.Connected], Failure> = baseUsers.map({ base in
			let connected = (basePosts.lastValidData?.data)
				.map({ $0.connectedTo(users: base).users })
				?? base
			return connected
		})

		let connectedComments: RemoteData<[Comment.Connected], Failure> = baseComments.map({ base in
			let connected = (basePosts.lastValidData?.data)
				.map({ base.connectedTo(posts: $0).comments })
				?? base
			return connected
		})

		return (connectedPosts, connectedUsers, connectedComments)
	}
}

extension Array where Element == Post.Connected {
	func connectedTo(users: [User.Connected]) -> (posts: [Post.Connected], users: [User.Connected]) {
		let usersByID = Dictionary(groupingByID: users)
		let connectedPosts = map({ post in
			updated(post, with: { $0.user = usersByID[post.userID]?.user })
		})

		let postsByUserID = Dictionary(grouping: self, by: { $0.userID })
		let connectedUsers = users.map({ user in
			updated(user, with: { $0.posts = postsByUserID[user.id]?.map({ $0.post }) })
		})

		return (posts: connectedPosts, users: connectedUsers)
	}
}

extension Array where Element == Comment.Connected {
	func connectedTo(posts: [Post.Connected]) -> (comments: [Comment.Connected], posts: [Post.Connected]) {
		let postsByID = Dictionary(groupingByID: posts)
		let connectedComments = map({ comment in
			updated(comment, with: { $0.post = postsByID[comment.postID]?.post })
		})

		let commentsByPostID = Dictionary(grouping: self, by: { $0.postID })
		let connectedPosts = posts.map({ post in
			updated(post, with: { $0.comments = commentsByPostID[post.id]?.map({ $0.comment }) })
		})

		return (comments: connectedComments, posts: connectedPosts)
	}
}

/// An error occurred when performing a fetch operation
enum FetchError: Error {
	/// The fetch was `cacheOnly`, and the resource was not present
	case missingResource
	/// A remote fetch failed due to the remote not being available
	case remoteUnavailable
	/// A remote fetch was performed with incorrect data
	case incorrectFetch
	/// A remote fetch succeeded, but the fetched resource was not as expected
	case badResource
}

/// A type specifying how to perform the fetch of a resource
enum FetchType {
	/// Fetch a resource only from a persistent storage, and fail if that's not present or corrupted
	case storageOnly
	/// Fetch a resource only from remote
	case remoteOnly(forced: Bool)
	/// Fetch a resource from a persistent storage, and if that fails fallback to remote
	case storageFirst(forced: Bool)
	/// Fetch a resource from remote, and if that fails fallback to storage
	case remoteFirst(forced: Bool)
}

typealias StoreData<T> = RemoteData<T, FetchError>

// MARK: - Logger
private let logger: Logger = .init(label: "􀈖 DataStore")
