import XCTest
@testable import Thread_Demo
import Combine

final class PostsStoreTests: XCTestCase {
	var postsSubject: PassthroughSubject<[Post], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var store: PostsStore = .init(getPosts: {
		self.postsSubject = .init()
		return self.postsSubject
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
extension PostsStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoPosts() {
		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoPosts() {
		store.fetch()
		store.$posts.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).retrieving), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasPosts() {
		store.fetch()
		postsSubject.send(Self.posts)
		postsSubject.send(completion: .finished)
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, Self.posts.count, "Should have the same number of posts that were sent")
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoPosts() {
		store.fetch()
		let error = FetchError.badResource
		postsSubject.send(completion: .failure(error))
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).failed(error)), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenAStoreWithPosts_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousPosts() {
		store.fetch()
		postsSubject.send(Self.previousPosts)
		postsSubject.send(completion: .finished)
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		store.$posts.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).retrieving), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, Self.previousPosts.count, "Should have the same number of posts that were sent previously")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewPosts() {
		store.fetch()
		postsSubject.send(Self.previousPosts)
		postsSubject.send(completion: .finished)
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		postsSubject.send(Self.posts)
		postsSubject.send(completion: .finished)
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, Self.posts.count, "Should have the same number of posts that were sent afterwards")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousPosts() {
		store.fetch()
		postsSubject.send(Self.previousPosts)
		postsSubject.send(completion: .finished)
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		let error = FetchError.badResource
		postsSubject.send(completion: .failure(error))
		store.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).failed(error)), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, Self.previousPosts.count, "Should have the same number of posts that were sent previously")
	}
}

// MARK: Utilities
private extension PostsStoreTests {
	static let previousPosts: [Post] = Array([Post].samples.prefix(5))
	static let posts: [Post] = Array([Post].samples.dropFirst(5))
}
