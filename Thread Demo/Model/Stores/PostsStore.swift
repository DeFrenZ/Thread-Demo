import Combine
import Foundation

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class PostsStore: ObservableObject {
	@Published private(set) var posts: StoreData<[Post]> = .init()
	@Stored(key: .posts) private var stored: [Post]?

	private let getPosts: () -> AnyPublisher<[Post], FetchError>
	private var getPostsCancellable: AnyCancellable?

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
		// ???: Might be better to not fetch at all if a fetch is already in progress, or give the option to choose
		getPostsCancellable?.cancel()

		posts.state = .retrieving
		var value: [Post]?
		getPostsCancellable = getPosts()
			// TODO: Retry for recoverable errors
			.receive(on: RunLoop.main)
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						// ???: Check that a value was actually received before finishing
						self.posts.lastValidData = value
						self.posts.state = .idle
					case .failure(let error):
						self.posts.state = .failed(error)
					}
					self.getPostsCancellable = nil
				},
				receiveValue: { value = $0 }
			)
	}
}
