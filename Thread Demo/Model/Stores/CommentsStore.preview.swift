import Combine

extension CommentsStore {
	static var sample: CommentsStore {
		.init(
			storage: [:] as MemoryStorage,
			getComments: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			}
		)
	}
}
