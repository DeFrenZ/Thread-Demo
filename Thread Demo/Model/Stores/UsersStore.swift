import Combine
import Foundation

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
		var value: [User.Connected]?
		getUsersCancellable = getUsers()
			// TODO: Retry for recoverable errors
			.map({ $0.map(User.Connected.init(user:)) })
			.receive(on: RunLoop.main)
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						// ???: Check that a value was actually received before finishing
						self.users.lastValidData = value
						self.users.state = .idle
					case .failure(let error):
						self.users.state = .failed(error)
					}
					self.getUsersCancellable = nil
				},
				receiveValue: { value = $0 }
			)
	}
}
