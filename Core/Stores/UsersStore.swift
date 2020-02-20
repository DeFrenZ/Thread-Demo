import Combine
import Foundation

/// An object managing all the data relative to users. It's responsible for retrieving them, storing them and vending them.
public final class UsersStore<S: Scheduler>: ObservableObject {
	@Published public private(set) var users: StoreData<[User]> = .init()
	@Stored(key: .users) private var stored: [User]?

	private let getUsers: GetUsers
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private let scheduler: S
	private var cancellables: Set<AnyCancellable> = []

	public init(
		storage: Storage,
		getUsers: @escaping GetUsers,
		scheduler: S
	) {
		self._stored.storage = storage
		self.getUsers = getUsers
		self.scheduler = scheduler

		try? fetchFromStorage()
	}

	public typealias GetUsers = () -> AnyPublisher<[User], FetchError>
}

extension UsersStore where S == RunLoop {
	public convenience init(
		storage: Storage,
		getUsers: @escaping GetUsers
	) {
		self.init(
			storage: storage,
			getUsers: getUsers,
			scheduler: .main
		)
	}
}

extension UsersStore {
	public func fetch(_ fetchType: FetchType) {
		switch (fetchType, users.lastValidData?.source) {
		case (.storageOnly, nil):
			try? fetchFromStorage()
		case (.remoteOnly(forced: false), nil),
			 (.remoteOnly(forced: false), .storage),
			 (.remoteOnly(forced: true), _),
			 (.storageFirst(forced: false), .storage),
			 (.storageFirst(forced: true), _?),
			 (.remoteFirst, .storage),
			 (.remoteFirst(forced: true), .remote):
			fetchFromRemote(fallbackToStorage: false)
		case (.storageFirst, nil):
			(try? fetchFromStorage())
				?? fetchFromRemote(fallbackToStorage: false)
		case (.remoteFirst, nil):
			fetchFromRemote(fallbackToStorage: true)
		case (.storageOnly, _?),
			 (.remoteOnly(forced: false), .remote),
			 (.storageFirst(forced: false), .remote),
			 (.remoteFirst(forced: false), .remote):
			break
		}
	}

	private func fetchFromStorage() throws {
		users.lastValidData = (try $stored.read(), .storage)
	}

	private func fetchFromRemote(fallbackToStorage: Bool) {
		// TODO: Make thread-safe
		cancellables.removeAll()
		users.state = .retrieving
		let publisher = getUsers()
			.receive(on: scheduler)

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [users] result in
				updated(users, with: { $0.setRemoteValue(to: result) })
			})
			.assign(to: \.users, on: self)
			.store(in: &cancellables)

		if fallbackToStorage {
			publisher
				.sink(receiveCompletion: { [weak self] in
					guard case .failure = $0 else { return }
					try? self?.fetchFromStorage()
				}, receiveValue: { _ in })
				.store(in: &cancellables)
		}
	}
}
