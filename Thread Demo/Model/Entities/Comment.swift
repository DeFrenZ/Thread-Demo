struct Comment: Identifiable {
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
	final class Connected: Identifiable {
		let comment: Comment
		weak var post: Post.Connected?

		init(comment: Comment) {
			self.comment = comment
		}

		subscript <T> (dynamicMember keyPath: KeyPath<Comment, T>) -> T { comment[keyPath: keyPath] }

		var id: Comment.ID { comment.id }
	}
}
