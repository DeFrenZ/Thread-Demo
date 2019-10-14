import XCTest
@testable import Thread_Demo
import Combine

final class UsersStoreTests: XCTestCase {
	var usersSubject: PassthroughSubject<[User], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var store: UsersStore = .init(getUsers: {
		self.usersSubject = .init()
		return self.usersSubject
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
extension UsersStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoPosts() {
		if case .idle = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).idle), but its state is \(store.users.state)")
		}
		XCTAssertNil(store.users.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoPosts() {
		store.fetch()
		store.$users.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).retrieving), but its state is \(store.users.state)")
		}
		XCTAssertNil(store.users.lastValidData, "Should not have posts yet")
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasPosts() {
		store.fetch()
		usersSubject.send(Self.users)
		usersSubject.send(completion: .finished)
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).idle), but its state is \(store.users.state)")
		}
		XCTAssertEqual(store.users.lastValidData?.count, Self.users.count, "Should have the same number of posts that were sent")
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoPosts() {
		store.fetch()
		let error = FetchError.badResource
		usersSubject.send(completion: .failure(error))
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).failed(error)), but its state is \(store.users.state)")
		}
		XCTAssertNil(store.users.lastValidData, "Should not have posts yet")
	}

	func test_givenAStoreWithPosts_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousPosts() {
		store.fetch()
		usersSubject.send(Self.previousUsers)
		usersSubject.send(completion: .finished)
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		store.$users.awaitSynchronouslyForNextOutput()

		if case .retrieving = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).retrieving), but its state is \(store.users.state)")
		}
		XCTAssertEqual(store.users.lastValidData?.count, Self.previousUsers.count, "Should have the same number of posts that were sent previously")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewPosts() {
		store.fetch()
		usersSubject.send(Self.previousUsers)
		usersSubject.send(completion: .finished)
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		usersSubject.send(Self.users)
		usersSubject.send(completion: .finished)
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		if case .idle = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).idle), but its state is \(store.users.state)")
		}
		XCTAssertEqual(store.users.lastValidData?.count, Self.users.count, "Should have the same number of posts that were sent afterwards")
	}

	func test_givenAStoreWithPosts_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousPosts() {
		store.fetch()
		usersSubject.send(Self.previousUsers)
		usersSubject.send(completion: .finished)
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		store.fetch()
		let error = FetchError.badResource
		usersSubject.send(completion: .failure(error))
		store.$users.awaitSynchronouslyForNextOutputs(count: 2)

		if case .failed = store.users.state {} else {
			XCTFail("The store should be \(type(of: store.users.state).failed(error)), but its state is \(store.users.state)")
		}
		XCTAssertEqual(store.users.lastValidData?.count, Self.previousUsers.count, "Should have the same number of posts that were sent previously")
	}
}

// MARK: Utilities
private extension UsersStoreTests {
	static let previousUsers: [User] = Array([User].samples.prefix(5))
	static let users: [User] = Array([User].samples.dropFirst(5))
}
