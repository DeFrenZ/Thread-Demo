import Combine

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class UsersStore: ObservableObject {
	@Published private(set) var users: RemoteData<[User.Connected]> = .init()

	private let getUsers: () -> AnyPublisher<[User], FetchError>
	private var getUsersCancellable: AnyCancellable?

	init(getUsers: @escaping () -> AnyPublisher<[User], FetchError>) {
		self.getUsers = getUsers
	}
}

extension UsersStore {
	func fetch() {
		// TODO: Make thread-safe
		// ???: Might be better to not fetch at all if a fetch is already in progress, or give the option to choose
		getUsersCancellable?.cancel()

		users.state = .retrieving
		getUsersCancellable = getUsers()
			// TODO: Retry for recoverable errors
			.map({ $0.map(User.Connected.init(user:)) })
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						self.users.state = .idle
						self.getUsersCancellable = nil
					case .failure(let error):
						self.users.state = .failed(error)
					}
				},
				receiveValue: { self.users.lastValidData = $0 }
			)
	}
}
