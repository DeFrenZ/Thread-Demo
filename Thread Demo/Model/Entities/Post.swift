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
	final class Connected {
		let post: Post
		weak var user: User.Connected?
		var comments: [Comment.Connected]?

		init(post: Post) {
			self.post = post
		}
	}
}
