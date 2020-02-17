import Combine

extension UsersStore where S == ImmediateScheduler {
	static var sample: UsersStore {
		.init(
			storage: [:] as MemoryStorage,
			getUsers: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	static var sampleLoaded: UsersStore {
		.init(
			storage: [.users: [User].samples!] as MemoryStorage,
			getUsers: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	static var sampleLoading: UsersStore {
		.init(
			storage: [:] as MemoryStorage,
			getUsers: { Empty(completeImmediately: false).eraseToAnyPublisher() },
			scheduler: .shared
		)
	}
}
