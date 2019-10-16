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
}
