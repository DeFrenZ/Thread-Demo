import Combine

extension CommentsStore {
	static var sample: CommentsStore {
		.init(getComments: {
			Just(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
