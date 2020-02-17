import Combine
import Foundation

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class PostsStore<S: Scheduler>: ObservableObject {
	@Published private(set) var posts: StoreData<[Post]> = .init()
	@Stored(key: .posts) private var stored: [Post]?

	private let getPosts: GetPosts
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private let scheduler: S
	private var cancellables: Set<AnyCancellable> = []

	init(
		storage: Storage,
		getPosts: @escaping GetPosts,
		scheduler: S
	) {
		self._stored.storage = storage
		self.getPosts = getPosts
		self.scheduler = scheduler

		try? fetchFromStorage()
	}

	typealias GetPosts = () -> AnyPublisher<[Post], FetchError>
}

extension PostsStore where S == RunLoop {
	convenience init(
		storage: Storage,
		getPosts: @escaping GetPosts
	) {
		self.init(
			storage: storage,
			getPosts: getPosts,
			scheduler: .main
		)
	}
}

extension PostsStore {
	func fetch(_ fetchType: FetchType) {
		switch (fetchType, posts.lastValidData?.source) {
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
		posts.lastValidData = (try $stored.read(), .storage)
	}

	private func fetchFromRemote(fallbackToStorage: Bool) {
		// TODO: Make thread-safe
		cancellables.removeAll()
		posts.state = .retrieving
		let publisher = getPosts()
			.receive(on: scheduler)

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [posts] result in
				updated(posts, with: { $0.setRemoteValue(to: result) })
			})
			.assign(to: \.posts, on: self)
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
