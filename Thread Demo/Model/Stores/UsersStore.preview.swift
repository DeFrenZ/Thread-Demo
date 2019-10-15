import Combine

extension UsersStore {
	static var sample: UsersStore {
		.init(getUsers: {
			Just(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
