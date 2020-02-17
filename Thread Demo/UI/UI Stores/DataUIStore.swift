import Combine
import Foundation

final class DataUIStore: ObservableObject {
	@Published private(set) var posts: StoreData<[Post.Connected]>
	@Published private(set) var users: StoreData<[User.Connected]>
	@Published private(set) var comments: StoreData<[Comment.Connected]>
	private let fetchAll: (FetchType) -> Void
	private var cancellable: Cancellable?

	init(
		initialPosts: StoreData<[Post.Connected]> = .init(),
		posts: AnyPublisher<StoreData<[Post.Connected]>, Never>,
		initialUsers: StoreData<[User.Connected]> = .init(),
		users: AnyPublisher<StoreData<[User.Connected]>, Never>,
		initialComments: StoreData<[Comment.Connected]> = .init(),
		comments: AnyPublisher<StoreData<[Comment.Connected]>, Never>,
		fetchAll: @escaping (FetchType) -> Void
	) {
		self.posts = initialPosts
		self.users = initialUsers
		self.comments = initialComments
		self.fetchAll = fetchAll

		bindValues(posts: posts, users: users, comments: comments)
	}

	private func bindValues(
		posts: AnyPublisher<StoreData<[Post.Connected]>, Never>,
		users: AnyPublisher<StoreData<[User.Connected]>, Never>,
		comments: AnyPublisher<StoreData<[Comment.Connected]>, Never>
	) {
		self.cancellable = posts
			.combineLatest(users, comments)
			.removeDuplicates(by: ==)
			// !!!: Avoid jarring UI updates. Also avoids a `SwiftUI.List` bug (iOS 13.0) that makes it layout incorrectly with quick updates
			.throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: true)
			.log(.info, on: logger)
			.sink(receiveValue: { [weak self] posts, users, comments in
				guard let self = self else { return }
				setIfUnequal(&self.posts, to: posts)
				setIfUnequal(&self.users, to: users)
				setIfUnequal(&self.comments, to: comments)
			})
	}

	func fetchAll(_ fetchType: FetchType = .remoteFirst(forced: false)) {
		logger.info("Fetching: \(public: String(describing: fetchType))")
		self.fetchAll(fetchType)
	}
}

// MARK: - Logger
private let logger: Logger = .init(label: "􀈞 DataUIStore")
