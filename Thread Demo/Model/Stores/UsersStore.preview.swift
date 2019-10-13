import Combine

extension UsersStore {
	static var sample: UsersStore {
		.init(getUsers: {
			Just<[User]>(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
