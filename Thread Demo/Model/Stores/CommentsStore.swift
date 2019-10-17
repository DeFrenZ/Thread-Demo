import Combine
import Foundation

/// An object managing all the data relative to comments. It's responsible for retrieving them, storing them and vending them.
final class CommentsStore: ObservableObject {
	@Published private(set) var comments: StoreData<[Comment]> = .init()
	@Stored(key: .comments) private var stored: [Comment]?

	private let getComments: () -> AnyPublisher<[Comment], FetchError>
	/// The cancellable of the last remote request. Might hold a value that represents an already completed fetch
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
		comments.state = .retrieving
		getCommentsCancellable = getComments()
			// TODO: Retry for recoverable errors
			.asResults()
			.map({ [comments] result in
				updated(comments, with: { $0.setValue(to: result) })
			})
			.receive(on: RunLoop.main)
			.assign(to: \.comments, on: self)
	}
}
