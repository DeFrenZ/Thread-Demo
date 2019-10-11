extension Post {
	init(apiModel: API.Post) {
		self.init(
			id: .init(value: apiModel.id),
			userID: .init(value: apiModel.userId),
			title: apiModel.title,
			body: apiModel.body
		)
	}
}
