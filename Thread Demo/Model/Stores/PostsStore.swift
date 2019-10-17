import Combine
import Foundation

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class PostsStore: ObservableObject {
	@Published private(set) var posts: StoreData<[Post]> = .init()
	@Stored(key: .posts) private var stored: [Post]?

	private let getPosts: () -> AnyPublisher<[Post], FetchError>
	/// The cancellables of the last remote request. Might hold values relative to an already completed fetch
	private var cancellables: Set<AnyCancellable> = []

	init(
		storage: Storage,
		getPosts: @escaping () -> AnyPublisher<[Post], FetchError>
	) {
		self._stored.storage = storage
		self.getPosts = getPosts
	}
}

extension PostsStore {
	func fetch() {
		// TODO: Make thread-safe
		cancellables.removeAll()
		posts.state = .retrieving
		let publisher = getPosts()

		publisher
			.ignoreErrors()
			.assign(to: \.stored, on: self)
			.store(in: &cancellables)

		publisher
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [posts] result in
				updated(posts, with: { $0.setValue(to: result) })
			})
			.receive(on: RunLoop.main)
			.assign(to: \.posts, on: self)
			.store(in: &cancellables)
	}
}
