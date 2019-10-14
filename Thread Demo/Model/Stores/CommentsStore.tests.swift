import XCTest
@testable import Thread_Demo
import Combine

final class CommentsStoreTests: XCTestCase {
	var commentsSubject: PassthroughSubject<[Comment], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var store: CommentsStore = .init(getComments: {
		self.commentsSubject = .init()
		return self.commentsSubject
			// Add buffer so that values sent before the subscription activates still go through
			.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
			.eraseToAnyPublisher()
	})

	override func setUp() {
		super.setUp()

		// Trigger the instantiation of the `lazy` property
		_ = store
	}
}

// MARK: Tests
extension CommentsStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoPosts() {
		if case .idle = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).idle), but its state is \(store.comments.state)")
		}
		XCTAssertNil(store.comments.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoPosts() {
		store.fetch()
		store.$comments.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).retrieving), but its state is \(store.comments.state)")
		}
		XCTAssertNil(store.comments.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasPosts() {
		store.fetch()
		commentsSubject.send(Self.comments)
		commentsSubject.send(completion: .finished)
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).idle), but its state is \(store.comments.state)")
		}
		XCTAssertEqual(store.comments.lastValidData?.count, Self.comments.count, "Should have the same number of posts that were sent")
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoPosts() {
		store.fetch()
		let error = FetchError.badResource
		commentsSubject.send(completion: .failure(error))
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).failed(error)), but its state is \(store.comments.state)")
		}
		XCTAssertNil(store.comments.lastValidData, "Should not have posts yet")
	}

	func test_givenAStoreWithPosts_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousPosts() {
		store.fetch()
		commentsSubject.send(Self.previousComments)
		commentsSubject.send(completion: .finished)
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		store.$comments.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).retrieving), but its state is \(store.comments.state)")
		}
		XCTAssertEqual(store.comments.lastValidData?.count, Self.previousComments.count, "Should have the same number of posts that were sent previously")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewPosts() {
		store.fetch()
		commentsSubject.send(Self.previousComments)
		commentsSubject.send(completion: .finished)
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		commentsSubject.send(Self.comments)
		commentsSubject.send(completion: .finished)
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).idle), but its state is \(store.comments.state)")
		}
		XCTAssertEqual(store.comments.lastValidData?.count, Self.comments.count, "Should have the same number of posts that were sent afterwards")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousPosts() {
		store.fetch()
		commentsSubject.send(Self.previousComments)
		commentsSubject.send(completion: .finished)
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		let error = FetchError.badResource
		commentsSubject.send(completion: .failure(error))
		store.$comments.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.comments.state {} else {
			XCTFail("The store should be \(type(of: store.comments.state).failed(error)), but its state is \(store.comments.state)")
		}
		XCTAssertEqual(store.comments.lastValidData?.count, Self.previousComments.count, "Should have the same number of posts that were sent previously")
	}
}

// MARK: Utilities
private extension CommentsStoreTests {
	static let previousComments: [Comment] = Array([Comment].samples.prefix(5))
	static let comments: [Comment] = Array([Comment].samples.dropFirst(5))
}
