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
	final class Connected {
		let comment: Comment
		weak var post: Post.Connected?

		init(comment: Comment) {
			self.comment = comment
		}
	}
}
