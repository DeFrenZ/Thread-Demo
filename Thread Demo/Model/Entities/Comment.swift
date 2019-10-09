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
