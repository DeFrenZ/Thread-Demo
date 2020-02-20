import Combine

#if ENABLE_SAMPLES
extension UsersStore where S == ImmediateScheduler {
	public static var sample: UsersStore {
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

	public static var sampleLoaded: UsersStore {
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

	public static var sampleLoading: UsersStore {
		.init(
			storage: [:] as MemoryStorage,
			getUsers: { Empty(completeImmediately: false).eraseToAnyPublisher() },
			scheduler: .shared
		)
	}
}
#endif
