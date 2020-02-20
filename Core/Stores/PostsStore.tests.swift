import XCTest
@testable import Core
import Combine

final class PostsStoreTests: XCTestCase {
	private var storage: MemoryStorage = [:]
	private var lastPostsSubject: PassthroughSubject<[Post], FetchError>!
	private var postsHistory: [StoreData<[Post]>] = []
	private var postsHistoryCancellable: Cancellable!
	// `lazy` to allow capture of other properties
	private lazy var store: PostsStore = .init(
		storage: self.storage,
		getPosts: {
			let subject = PassthroughSubject<[Post], FetchError>()
			self.lastPostsSubject = subject
			return subject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		},
		scheduler: ImmediateScheduler.shared
	)

	override func setUp() {
		super.setUp()

		postsHistoryCancellable = store.$posts
			.scan([], { $0 + [$1] })
			.assign(to: \.postsHistory, on: self)
	}
}

// MARK: Tests
extension PostsStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoPosts() {
		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoPosts() {
		store.fetch(.remoteOnly(forced: false))

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasPosts() {
		store.fetch(.remoteOnly(forced: false))
		lastPostsSubject.send(Self.posts)
		lastPostsSubject.send(completion: .finished)

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.posts, source: .remote), state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoPosts() {
		store.fetch(.remoteOnly(forced: false))
		lastPostsSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: nil, state: .failed(Self.error)),
		])
	}

	func test_givenAStoreWithPosts_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousPosts() {
		store.fetch(.remoteOnly(forced: false))
		lastPostsSubject.send(Self.previousPosts)
		lastPostsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .retrieving),
		])
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewPosts() {
		store.fetch(.remoteOnly(forced: false))
		lastPostsSubject.send(Self.previousPosts)
		lastPostsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastPostsSubject.send(Self.posts)
		lastPostsSubject.send(completion: .finished)

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.posts, source: .remote), state: .idle),
		])
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousPosts() {
		store.fetch(.remoteOnly(forced: false))
		lastPostsSubject.send(Self.previousPosts)
		lastPostsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastPostsSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(postsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.previousPosts, source: .remote), state: .failed(Self.error)),
		])
	}
}

// MARK: Utilities
private extension PostsStoreTests {
	static let previousPosts: [Post] = Array([Post].samples.prefix(5))
	static let posts: [Post] = Array([Post].samples.dropFirst(5))
	static let error: FetchError = .badResource
}
