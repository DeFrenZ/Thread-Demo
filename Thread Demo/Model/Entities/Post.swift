struct Post: Identifiable, Hashable {
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
	struct Connected: Identifiable, Hashable {
		let post: Post
		var user: User?
		var comments: [Comment]?

		subscript <T> (dynamicMember keyPath: KeyPath<Post, T>) -> T { post[keyPath: keyPath] }

		var id: Post.ID { post.id }
	}
}
