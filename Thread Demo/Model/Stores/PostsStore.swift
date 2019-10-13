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
		getPostsCancellable = getPosts()
			// TODO: Retry for recoverable errors
			.map({ $0.map(Post.Connected.init(post:)) })
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						self.posts.state = .idle
						self.getPostsCancellable = nil
					case .failure(let error):
						self.posts.state = .failed(error)
					}
				},
				receiveValue: { self.posts.lastValidData = $0 }
			)
	}
}
