import XCTest
@testable import Thread_Demo
import Combine

final class PostsStoreTests: XCTestCase {
	var postsSubject: PassthroughSubject<[Post], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var store: PostsStore = .init(getPosts: {
		self.postsSubject = .init()
		return self.postsSubject.eraseToAnyPublisher()
	})
}

// MARK: Tests
extension PostsStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoPosts() {
		// Trigger the instantiation of the `lazy` property
		_ = store

		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoPosts() {
		store.fetch()

		if case .retrieving = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).retrieving), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasPosts() {
		store.fetch()
		let posts: [Post] = [
			.init(id: .init(value: 1), userID: .init(value: 1), title: "This is a post", body: "And this is a body"),
			.init(id: .init(value: 2), userID: .init(value: 1), title: "This is another post", body: "And this is another body"),
			.init(id: .init(value: 3), userID: .init(value: 2), title: "This is not a post", body: "And this is sentence is false"),
		]
		postsSubject.send(posts)
		postsSubject.send(completion: .finished)

		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, posts.count, "Should have the same number of posts that were sent")
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoPosts() {
		store.fetch()
		let error = FetchError.unrecognized(StringError(message: "Forced failure"))
		postsSubject.send(completion: .failure(error))

		if case .failed = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).failed(error)), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}

	func test_givenAStoreWithPosts_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousPosts() {
		store.fetch()
		let previousPosts: [Post] = [
			.init(id: .init(value: 3), userID: .init(value: 1), title: "This is an old post", body: "And this is now irrelevant"),
		]
		postsSubject.send(previousPosts)
		postsSubject.send(completion: .finished)

		store.fetch()

		if case .retrieving = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).retrieving), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, previousPosts.count, "Should have the same number of posts that were sent previously")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewPosts() {
		store.fetch()
		let previousPosts: [Post] = [
			.init(id: .init(value: 3), userID: .init(value: 1), title: "This is an old post", body: "And this is now irrelevant"),
		]
		postsSubject.send(previousPosts)
		postsSubject.send(completion: .finished)

		store.fetch()
		let posts: [Post] = [
			.init(id: .init(value: 1), userID: .init(value: 1), title: "This is a post", body: "And this is a body"),
			.init(id: .init(value: 2), userID: .init(value: 1), title: "This is another post", body: "And this is another body"),
			.init(id: .init(value: 3), userID: .init(value: 2), title: "This is not a post", body: "And this is sentence is false"),
		]
		postsSubject.send(posts)
		postsSubject.send(completion: .finished)

		if case .idle = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).idle), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, posts.count, "Should have the same number of posts that were sent afterwards")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousPosts() {
		store.fetch()
		let previousPosts: [Post] = [
			.init(id: .init(value: 3), userID: .init(value: 1), title: "This is an old post", body: "And this is now irrelevant"),
		]
		postsSubject.send(previousPosts)
		postsSubject.send(completion: .finished)

		store.fetch()
		let error = FetchError.unrecognized(StringError(message: "Forced failure"))
		postsSubject.send(completion: .failure(error))

		if case .failed = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).failed(error)), but its state is \(store.posts.state)")
		}
		XCTAssertEqual(store.posts.lastValidData?.count, previousPosts.count, "Should have the same number of posts that were sent previously")
	}

	func test_givenAStoreThatIsFetching_whenItFetches_andNoResponseIsRetrievedYet_andPreviousFetchCompletes_thenItsRetrieving_andHasNoPosts() {
		store.fetch()
		let previousSubject = postsSubject!

		store.fetch()
		let previousPosts: [Post] = [
			.init(id: .init(value: 3), userID: .init(value: 1), title: "This is an old post", body: "And this is now irrelevant"),
		]
		previousSubject.send(previousPosts)
		previousSubject.send(completion: .finished)

		if case .retrieving = store.posts.state {} else {
			XCTFail("The store should be \(type(of: store.posts.state).retrieving), but its state is \(store.posts.state)")
		}
		XCTAssertNil(store.posts.lastValidData, "Should not have posts yet")
	}
}
