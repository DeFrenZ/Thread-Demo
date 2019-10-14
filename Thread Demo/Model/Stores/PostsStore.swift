import Combine

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class PostsStore: ObservableObject {
	@Published private(set) var posts: RemoteData<[Post.Connected]> = .init()

	private let getPosts: () -> AnyPublisher<[Post], FetchError>
	private var getPostsCancellable: AnyCancellable?

	init(getPosts: @escaping () -> AnyPublisher<[Post], FetchError>) {
		self.getPosts = getPosts
	}
}

extension PostsStore {
	func fetch() {
		// TODO: Make thread-safe
		// ???: Might be better to not fetch at all if a fetch is already in progress, or give the option to choose
		getPostsCancellable?.cancel()

		posts.state = .retrieving
		var value: [Post.Connected]?
		getPostsCancellable = getPosts()
			// TODO: Retry for recoverable errors
			.map({ $0.map(Post.Connected.init(post:)) })
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
