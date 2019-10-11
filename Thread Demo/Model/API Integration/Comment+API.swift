extension Comment {
	init(apiModel: API.Comment) {
		self.init(
			id: .init(value: apiModel.id),
			postID: .init(value: apiModel.postId),
			authorName: apiModel.name,
			authorEmail: apiModel.email,
			body: apiModel.body
		)
	}
}
