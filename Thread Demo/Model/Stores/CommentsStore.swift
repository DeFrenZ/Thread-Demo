import Combine
import Foundation

/// An object managing all the data relative to comments. It's responsible for retrieving them, storing them and vending them.
final class CommentsStore: ObservableObject {
	@Published private(set) var comments: StoreData<[Comment]> = .init()
	@Stored(key: .comments) private var stored: [Comment]?

	private let getComments: () -> AnyPublisher<[Comment], FetchError>
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private var cancellables: Set<AnyCancellable> = []

	init(
		storage: Storage,
		getComments: @escaping () -> AnyPublisher<[Comment], FetchError>
	) {
		self._stored.storage = storage
		self.getComments = getComments
	}
}

extension CommentsStore {
	func fetch(_ fetchType: FetchType) {
		switch fetchType {
		case .storageOnly:
			try? fetchFromStorage()
		case .remoteOnly:
			fetchFromRemote(fallbackToStorage: false)
		case .storageFirst:
			(try? fetchFromStorage())
				?? fetchFromRemote(fallbackToStorage: false)
		case .remoteFirst:
			fetchFromRemote(fallbackToStorage: true)
		}
	}

	private func fetchFromStorage() throws {
		comments = .init(
			lastValidData: try $stored.read(),
			state: .idle,
			source: .storage
		)
	}

	private func fetchFromRemote(fallbackToStorage: Bool) {
		// TODO: Make thread-safe
		cancellables.removeAll()
		comments.state = .retrieving
		let publisher = getComments()

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [comments] result in
				updated(comments, with: { $0.setValue(to: result, source: .remote) })
			})
			.receive(on: RunLoop.main)
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
