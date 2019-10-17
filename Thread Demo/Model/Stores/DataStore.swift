import Combine
import Foundation

/// An object managing the data of multiple stores. It provides access to higher level operations, and keeps the data in sync.
final class DataStore: ObservableObject {
	@Published private(set) var posts: StoreData<[Post.Connected]> = .init()
	@Published private(set) var users: StoreData<[User.Connected]> = .init()
	@Published private(set) var comments: StoreData<[Comment.Connected]> = .init()

	private let postsStore: PostsStore
	private let usersStore: UsersStore
	private let commentsStore: CommentsStore
	private var cancellable: AnyCancellable?

	init(
		postsStore: PostsStore,
		usersStore: UsersStore,
		commentsStore: CommentsStore
	) {
		self.postsStore = postsStore
		self.usersStore = usersStore
		self.commentsStore = commentsStore

		bindToChildrenStores()
	}

	private func bindToChildrenStores() {
		self.cancellable = postsStore.$posts
			.combineLatest(usersStore.$users, commentsStore.$comments)
			.removeDuplicates(by: ==)
			// !!!: Avoid jarring UI updates. Also avoids a `SwiftUI.List` bug (iOS 13.0) that makes it layout incorrectly with quick updates
			.debounce(for: .seconds(0.3), scheduler: RunLoop.main)
			.map(Self.connectChildrenData(posts:users:comments:))
			.sink(receiveValue: { [weak self] posts, users, comments in
				guard let self = self else { return }
				setIfUnequal(&self.posts, to: posts)
				setIfUnequal(&self.users, to: users)
				setIfUnequal(&self.comments, to: comments)
			})
	}
}

extension DataStore {
	func fetchAll(_ fetchType: FetchType = .storageFirst) {
		postsStore.fetch(fetchType)
		// ???: Consider not fetching the rest until a post detail is shown, but the list looks better with the additional data
		usersStore.fetch(fetchType)
		commentsStore.fetch(fetchType)
	}

	static func connectChildrenData(
		posts: StoreData<[Post]>,
		users: StoreData<[User]>,
		comments: StoreData<[Comment]>
	) -> (
		posts: StoreData<[Post.Connected]>,
		users: StoreData<[User.Connected]>,
		comments: StoreData<[Comment.Connected]>
	) {
		let basePosts = posts.map({ $0.map({ Post.Connected(post: $0) }) })
		let baseUsers = users.map({ $0.map({ User.Connected(user: $0) }) })
		let baseComments = comments.map({ $0.map({ Comment.Connected(comment: $0) }) })

		let connectedPosts: StoreData<[Post.Connected]> = basePosts.map({ base in
			let withUsers = baseUsers.lastValidData
				.map({ Self.connectPosts(base, toUsers: $0).posts })
				?? base
			let connected = baseComments.lastValidData
				.map({ Self.connectComments($0, toPosts: withUsers).posts })
				?? withUsers
			return connected
		})

		let connectedUsers: StoreData<[User.Connected]> = baseUsers.map({ base in
			let connected = basePosts.lastValidData
				.map({ Self.connectPosts($0, toUsers: base).users })
				?? base
			return connected
		})

		let connectedComments: StoreData<[Comment.Connected]> = baseComments.map({ base in
			let connected = basePosts.lastValidData
				.map({ Self.connectComments(base, toPosts: $0).comments })
				?? base
			return connected
		})

		return (connectedPosts, connectedUsers, connectedComments)
	}

	static func connectPosts(_ posts: [Post.Connected], toUsers users: [User.Connected]) -> (posts: [Post.Connected], users: [User.Connected]) {
		let usersByID = Dictionary(groupingByID: users)
		let connectedPosts = posts.map({ post in
			updated(post, with: { $0.user = usersByID[post.userID]?.user })
		})

		let postsByUserID = Dictionary(grouping: posts, by: { $0.userID })
		let connectedUsers = users.map({ user in
			updated(user, with: { $0.posts = postsByUserID[user.id]?.map({ $0.post }) })
		})

		return (posts: connectedPosts, users: connectedUsers)
	}

	static func connectComments(_ comments: [Comment.Connected], toPosts posts: [Post.Connected]) -> (comments: [Comment.Connected], posts: [Post.Connected]) {
		let postsByID = Dictionary(groupingByID: posts)
		let connectedComments = comments.map({ comment in
			updated(comment, with: { $0.post = postsByID[comment.postID]?.post })
		})

		let commentsByPostID = Dictionary(grouping: comments, by: { $0.postID })
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
	case remoteOnly
	/// Fetch a resource from a persistent storage, and if that fails fallback to remote
	case storageFirst
}

typealias StoreData<T> = RemoteData<T, FetchError>
