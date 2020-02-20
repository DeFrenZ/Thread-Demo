import Combine
import XCTest
@testable import Core

final class CommentsStoreTests: XCTestCase {
	private var storage: MemoryStorage = [:]
	private var lastCommentsSubject: PassthroughSubject<[Comment], FetchError>!
	private var commentsHistory: [StoreData<[Comment]>] = []
	private var commentsHistoryCancellable: Cancellable!
	// `lazy` to allow capture of other properties
	private lazy var store: CommentsStore = .init(
		storage: self.storage,
		getComments: {
			let subject = PassthroughSubject<[Comment], FetchError>()
			self.lastCommentsSubject = subject
			return subject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		},
		scheduler: ImmediateScheduler.shared
	)

	override func setUp() {
		super.setUp()

		commentsHistoryCancellable = store.$comments
			.scan([], { $0 + [$1] })
			.assign(to: \.commentsHistory, on: self)
	}
}

// MARK: Tests
extension CommentsStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoComments() {
		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoComments() {
		store.fetch(.remoteOnly(forced: false))

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasComments() {
		store.fetch(.remoteOnly(forced: false))
		lastCommentsSubject.send(Self.comments)
		lastCommentsSubject.send(completion: .finished)

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.comments, source: .remote), state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoComments() {
		store.fetch(.remoteOnly(forced: false))
		lastCommentsSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: nil, state: .failed(Self.error)),
		])
	}

	func test_givenAStoreWithComments_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousComments() {
		store.fetch(.remoteOnly(forced: false))
		lastCommentsSubject.send(Self.previousComments)
		lastCommentsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .retrieving),
		])
	}

	func test_givenAStoreWithComments_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewComments() {
		store.fetch(.remoteOnly(forced: false))
		lastCommentsSubject.send(Self.previousComments)
		lastCommentsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastCommentsSubject.send(Self.comments)
		lastCommentsSubject.send(completion: .finished)

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.comments, source: .remote), state: .idle),
		])
	}

	func test_givenAStoreWithComments_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousComments() {
		store.fetch(.remoteOnly(forced: false))
		lastCommentsSubject.send(Self.previousComments)
		lastCommentsSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastCommentsSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(commentsHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.previousComments, source: .remote), state: .failed(Self.error)),
		])
	}
}

// MARK: Utilities
private extension CommentsStoreTests {
	static let previousComments: [Comment] = Array([Comment].samples.prefix(5))
	static let comments: [Comment] = Array([Comment].samples.dropFirst(5))
	static let error: FetchError = .badResource
}
