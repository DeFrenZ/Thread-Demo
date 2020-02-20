import Combine
import XCTest
@testable import Core

final class UsersStoreTests: XCTestCase {
	private var storage: MemoryStorage = [:]
	private var lastUsersSubject: PassthroughSubject<[User], FetchError>!
	private var usersHistory: [StoreData<[User]>] = []
	private var usersHistoryCancellable: Cancellable!
	// `lazy` to allow capture of other properties
	private lazy var store: UsersStore = .init(
		storage: self.storage,
		getUsers: {
			let subject = PassthroughSubject<[User], FetchError>()
			self.lastUsersSubject = subject
			return subject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		},
		scheduler: ImmediateScheduler.shared
	)

	override func setUp() {
		super.setUp()

		usersHistoryCancellable = store.$users
			.scan([], { $0 + [$1] })
			.assign(to: \.usersHistory, on: self)
	}
}

// MARK: Tests
extension UsersStoreTests {
	func test_givenANewStore_thenItsIdle_andHasNoUsers() {
		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasNoUsers() {
		store.fetch(.remoteOnly(forced: false))

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAResponse_thenItsIdle_andHasUsers() {
		store.fetch(.remoteOnly(forced: false))
		lastUsersSubject.send(Self.users)
		lastUsersSubject.send(completion: .finished)

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.users, source: .remote), state: .idle),
		])
	}

	func test_givenANewStore_whenItFetches_andReceivesAFailure_thenItsFailed_andHasNoUsers() {
		store.fetch(.remoteOnly(forced: false))
		lastUsersSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: nil, state: .failed(Self.error)),
		])
	}

	func test_givenAStoreWithUsers_whenItFetches_andNoResponseIsRetrievedYet_thenItsRetrieving_andHasThePreviousUsers() {
		store.fetch(.remoteOnly(forced: false))
		lastUsersSubject.send(Self.previousUsers)
		lastUsersSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .retrieving),
		])
	}

	func test_givenAStoreWithUsers_whenItFetches_andReceivesAResponse_thenItsIdle_andHasTheNewUsers() {
		store.fetch(.remoteOnly(forced: false))
		lastUsersSubject.send(Self.previousUsers)
		lastUsersSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastUsersSubject.send(Self.users)
		lastUsersSubject.send(completion: .finished)

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.users, source: .remote), state: .idle),
		])
	}

	func test_givenAStoreWithUsers_whenItFetches_andReceivesAFailure_thenItsFailed_andHasThePreviousUsers() {
		store.fetch(.remoteOnly(forced: false))
		lastUsersSubject.send(Self.previousUsers)
		lastUsersSubject.send(completion: .finished)

		store.fetch(.remoteOnly(forced: true))
		lastUsersSubject.send(completion: .failure(Self.error))

		XCTAssertEqual(usersHistory, [
			.init(lastValidData: nil, state: .idle),
			.init(lastValidData: nil, state: .retrieving),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .idle),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .retrieving),
			.init(lastValidData: (data: Self.previousUsers, source: .remote), state: .failed(Self.error)),
		])
	}
}

// MARK: Utilities
extension UsersStoreTests {
	fileprivate static let previousUsers: [User] = Array([User].samples.prefix(5))
	fileprivate static let users: [User] = Array([User].samples.dropFirst(5))
	fileprivate static let error: FetchError = .badResource
}
