import Combine

extension CommentsStore {
	static var sample: CommentsStore {
		.init(getComments: {
			Just<[Comment]>(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
