import Combine

extension UsersStore {
	static var sample: UsersStore {
		.init(
			storage: [:] as MemoryStorage,
			getUsers: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			}
		)
	}

	static var sampleLoading: UsersStore {
		.init(
			storage: [:] as MemoryStorage,
			getUsers: { Empty(completeImmediately: false).eraseToAnyPublisher() }
		)
	}
}
