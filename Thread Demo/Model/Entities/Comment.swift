struct Comment: Identifiable, Hashable {
	var id: ID
	var postID: Post.ID
	var authorName: String
	var authorEmail: Email
	var body: String

	struct ID: Hashable {
		var value: Int
	}
}

extension Comment {
	@dynamicMemberLookup
	struct Connected: Identifiable, Hashable {
		let comment: Comment
		var post: Post?

		subscript <T> (dynamicMember keyPath: KeyPath<Comment, T>) -> T { comment[keyPath: keyPath] }

		var id: Comment.ID { comment.id }
	}
}
