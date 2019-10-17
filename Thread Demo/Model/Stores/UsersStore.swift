import Combine
import Foundation

/// An object managing all the data relative to users. It's responsible for retrieving them, storing them and vending them.
final class UsersStore: ObservableObject {
	@Published private(set) var users: StoreData<[User]> = .init()
	@Stored(key: .users) private var stored: [User]?

	private let getUsers: () -> AnyPublisher<[User], FetchError>
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private var cancellables: Set<AnyCancellable> = []

	init(
		storage: Storage,
		getUsers: @escaping () -> AnyPublisher<[User], FetchError>
	) {
		self._stored.storage = storage
		self.getUsers = getUsers
	}
}

extension UsersStore {
	func fetch(_ fetchType: FetchType = .storageFirst) {
		switch fetchType {
		case .storageOnly:
			try? fetchFromStorage()
		case .remoteOnly:
			fetchFromRemote()
		case .storageFirst:
			(try? fetchFromStorage())
				?? fetchFromRemote()
		}
	}

	private func fetchFromStorage() throws {
		users = .init(
			lastValidData: try $stored.read(),
			state: .idle,
			source: .storage
		)
	}

	private func fetchFromRemote() {
		// TODO: Make thread-safe
		cancellables.removeAll()
		users.state = .retrieving
		let publisher = getUsers()

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [users] result in
				updated(users, with: { $0.setValue(to: result, source: .remote) })
			})
			.receive(on: RunLoop.main)
			.assign(to: \.users, on: self)
			.store(in: &cancellables)
	}
}
