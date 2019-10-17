import Combine
import Foundation

/// An object managing all the data relative to users. It's responsible for retrieving them, storing them and vending them.
final class UsersStore: ObservableObject {
	@Published private(set) var users: StoreData<[User]> = .init()
	@Stored(key: .users) private var stored: [User]?

	private let getUsers: () -> AnyPublisher<[User], FetchError>
	/// The cancellable of the last remote request. Might hold a value that represents an already completed fetch
	private var getUsersCancellable: AnyCancellable?

	init(
		storage: Storage,
		getUsers: @escaping () -> AnyPublisher<[User], FetchError>
	) {
		self._stored.storage = storage
		self.getUsers = getUsers
	}
}

extension UsersStore {
	func fetch() {
		// TODO: Make thread-safe
		users.state = .retrieving
		getUsersCancellable = getUsers()
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [users] result in
				updated(users, with: { $0.setValue(to: result) })
			})
			.receive(on: RunLoop.main)
			.assign(to: \.users, on: self)
	}
}
