import Combine
import Foundation

/// An object managing all the data relative to comments. It's responsible for retrieving them, storing them and vending them.
public final class CommentsStore<S: Scheduler>: ObservableObject {
	@Published public private(set) var comments: StoreData<[Comment]> = .init()
	@Stored(key: .comments) private var stored: [Comment]?

	private let getComments: GetComments
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private let scheduler: S
	private var cancellables: Set<AnyCancellable> = []

	public init(
		storage: Storage,
		getComments: @escaping GetComments,
		scheduler: S
	) {
		self._stored.storage = storage
		self.getComments = getComments
		self.scheduler = scheduler

		try? fetchFromStorage()
	}

	public typealias GetComments = () -> AnyPublisher<[Comment], FetchError>
}

extension CommentsStore where S == RunLoop {
	public convenience init(
		storage: Storage,
		getComments: @escaping GetComments
	) {
		self.init(
			storage: storage,
			getComments: getComments,
			scheduler: .main
		)
	}
}

extension CommentsStore {
	public func fetch(_ fetchType: FetchType) {
		switch (fetchType, comments.lastValidData?.source) {
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
		comments.lastValidData = (try $stored.read(), .storage)
	}

	private func fetchFromRemote(fallbackToStorage: Bool) {
		// TODO: Make thread-safe
		cancellables.removeAll()
		comments.state = .retrieving
		let publisher = getComments()
			.receive(on: scheduler)

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [comments] result in
				updated(comments, with: { $0.setRemoteValue(to: result) })
			})
			.assign(to: \.comments, on: self)
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
