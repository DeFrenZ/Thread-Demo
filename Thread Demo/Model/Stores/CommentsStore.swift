import Combine
import Foundation

/// An object managing all the data relative to posts. It's responsible for retrieving them, storing them and vending them.
final class CommentsStore: ObservableObject {
	@Published private(set) var comments: StoreData<[Comment]> = .init()
	@Stored(key: .comments) private var stored: [Comment]?

	private let getComments: () -> AnyPublisher<[Comment], FetchError>
	private var getCommentsCancellable: AnyCancellable?

	init(
		storage: Storage,
		getComments: @escaping () -> AnyPublisher<[Comment], FetchError>
	) {
		self._stored.storage = storage
		self.getComments = getComments
	}
}

extension CommentsStore {
	func fetch() {
		// TODO: Make thread-safe
		// ???: Might be better to not fetch at all if a fetch is already in progress, or give the option to choose
		getCommentsCancellable?.cancel()

		comments.state = .retrieving
		var value: [Comment]?
		getCommentsCancellable = getComments()
			// TODO: Retry for recoverable errors
			.receive(on: RunLoop.main)
			.sink(
				// !!!: `self` is strongly retained, but once the pipeline finishes this gets released so there's no permanent retain cycle
				receiveCompletion: {
					switch $0 {
					case .finished:
						// ???: Check that a value was actually received before finishing
						self.comments.lastValidData = value
						self.comments.state = .idle
					case .failure(let error):
						self.comments.state = .failed(error)
					}
					self.getCommentsCancellable = nil
				},
				receiveValue: { value = $0 }
			)
	}
}
