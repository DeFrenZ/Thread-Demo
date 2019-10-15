import Combine

/// An object managing the data of multiple stores. It provides access to higher level operations, and keeps the data in sync.
final class DataStore: ObservableObject {
	let postsStore: PostsStore
	let usersStore: UsersStore
	let commentsStore: CommentsStore
	private var cancellable: AnyCancellable?

	init(
		postsStore: PostsStore,
		usersStore: UsersStore,
		commentsStore: CommentsStore
	) {
		self.postsStore = postsStore
		self.usersStore = usersStore
		self.commentsStore = commentsStore

		self.cancellable = postsStore.$posts
			.combineLatest(usersStore.$users, commentsStore.$comments)
			.sink(receiveValue: { [weak self] _ in self?.connectModels() })
	}
}

extension DataStore {
	func fetchAll() {
		postsStore.fetch()
		usersStore.fetch()
		commentsStore.fetch()
	}

	static func connectPosts(_ posts: [Post.Connected], toUsers users: [User.Connected]) {
		let usersByID = Dictionary(groupingByID: users)
		for post in posts {
			post.user = usersByID[post.post.userID]
		}

		let postsByUserID = Dictionary(grouping: posts, by: { $0.userID })
		for user in users {
			user.posts = postsByUserID[user.id]
		}
	}

	static func connectComments(_ comments: [Comment.Connected], toPosts posts: [Post.Connected]) {
		let postsByID = Dictionary(groupingByID: posts)
		for comment in comments {
			comment.post = postsByID[comment.comment.postID]
		}

		let commentsByPostID = Dictionary(grouping: comments, by: { $0.postID })
		for post in posts {
			post.comments = commentsByPostID[post.id]
		}
	}
}

private extension DataStore {
	var posts: RemoteData<[Post.Connected]> { postsStore.posts }
	var users: RemoteData<[User.Connected]> { usersStore.users }
	var comments: RemoteData<[Comment.Connected]> { commentsStore.comments }

	func connectModels() {
		connectPostsToUsers()
		connectCommentsToPosts()
	}

	func connectPostsToUsers() {
		guard let users = users.lastValidData else { return }

		guard let posts = posts.lastValidData else {
			for user in users {
				user.posts = nil
			}
			return
		}

		Self.connectPosts(posts, toUsers: users)
	}

	func connectCommentsToPosts() {
		guard let posts = posts.lastValidData else { return }

		guard let comments = comments.lastValidData else {
			for post in posts {
				post.comments = nil
			}
			return
		}

		Self.connectComments(comments, toPosts: posts)
	}
}

enum FetchError: Error {
	case remoteUnavailable
	case incorrectFetch
	case badResource
}
