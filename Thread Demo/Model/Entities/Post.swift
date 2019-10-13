struct Post: Identifiable {
	var id: ID
	var userID: User.ID
	var title: String
	var body: String

	struct ID: Hashable {
		var value: Int
	}
}

extension Post {
	@dynamicMemberLookup
	final class Connected: Identifiable {
		let post: Post
		weak var user: User.Connected?
		var comments: [Comment.Connected]?

		init(post: Post) {
			self.post = post
		}

		subscript <T> (dynamicMember keyPath: KeyPath<Post, T>) -> T { post[keyPath: keyPath] }

		var id: Post.ID { post.id }
	}
}
