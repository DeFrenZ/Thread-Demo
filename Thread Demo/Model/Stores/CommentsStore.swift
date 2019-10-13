import Combine

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class CommentsStore: ObservableObject {
	@Published private(set) var comments: RemoteData<[Comment.Connected]> = .init()

	private let getComments: () -> AnyPublisher<[Comment], FetchError>
	private var getCommentsCancellable: AnyCancellable?

	init(getComments: @escaping () -> AnyPublisher<[Comment], FetchError>) {
		self.getComments = getComments
	}
}

extension CommentsStore {
	func fetch() {
		// TODO: Make thread-safe
		// ???: Might be better to not fetch at all if a fetch is already in progress, or give the option to choose
		getCommentsCancellable?.cancel()

		comments.state = .retrieving
		getCommentsCancellable = getComments()
			// TODO: Retry for recoverable errors
			.map({ $0.map(Comment.Connected.init(comment:)) })
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						self.comments.state = .idle
						self.getCommentsCancellable = nil
					case .failure(let error):
						self.comments.state = .failed(error)
					}
				},
				receiveValue: { self.comments.lastValidData = $0 }
			)
	}
}
