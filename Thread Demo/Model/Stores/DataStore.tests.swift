import XCTest
@testable import Thread_Demo
import Combine

final class DataStoreTests: XCTestCase {
	var storage: MemoryStorage = [:]
	var postsSubject: PassthroughSubject<[Post], FetchError>!
	lazy var postsStore: PostsStore = .init(
		storage: self.storage,
		getPosts: {
			self.postsSubject = .init()
			return self.postsSubject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		}
	)
	var usersSubject: PassthroughSubject<[User], FetchError>!
	lazy var usersStore: UsersStore = .init(
		storage: self.storage,
		getUsers: {
			self.usersSubject = .init()
			return self.usersSubject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		}
	)
	var commentsSubject: PassthroughSubject<[Comment], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var commentsStore: CommentsStore = .init(
		storage: self.storage,
		getComments: {
			self.commentsSubject = .init()
			return self.commentsSubject
				// Add buffer so that values sent before the subscription activates still go through
				.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
				.eraseToAnyPublisher()
		}
	)
	lazy var store: DataStore = .init(
		postsStore: self.postsStore,
		usersStore: self.usersStore,
		commentsStore: self.commentsStore
	)

	override func setUp() {
		super.setUp()

		_ = store
	}
}

// MARK: Tests
extension DataStoreTests {
	func test_givenANewStore_whenFetching_thenAllStoresAreFetching() {
		store.fetchAll()

		if case .retrieving = postsStore.posts.state {} else {
			XCTFail("The store should be \(type(of: postsStore.posts.state).idle), but its state is \(postsStore.posts.state)")
		}
		if case .retrieving = usersStore.users.state {} else {
			XCTFail("The store should be \(type(of: usersStore.users.state).idle), but its state is \(usersStore.users.state)")
		}
		if case .retrieving = commentsStore.comments.state {} else {
			XCTFail("The store should be \(type(of: commentsStore.comments.state).idle), but its state is \(commentsStore.comments.state)")
		}
	}

	func test_givenANewStore_whenValuesArePublished_thenTheyGetConnected() {
		store.fetchAll()
		postsSubject.send(.samples)
		postsSubject.send(completion: .finished)
		usersSubject.send(.samples)
		usersSubject.send(completion: .finished)
		commentsSubject.send(.samples)
		commentsSubject.send(completion: .finished)
		// TODO: Should wait aynchronously for all three publishers, but not synchronously on each
		postsStore.$posts.awaitSynchronouslyForNextOutputs(count: 2)

		assertPostsAreConnectedToUsers()
		assertCommentsAreConnectedToPosts()
	}
}

// MARK: Utilities
private extension DataStoreTests {
	func assertPostsAreConnectedToUsers(file: StaticString = #file, line: UInt = #line) {
		for post in store.posts.lastValidData ?? [] {
			if let connectedUser = store.users.lastValidData?.first(where: { $0.id == post.userID }) {
				XCTAssertEqual(post.user, connectedUser.user, "There should be a connected user", file: file, line: line)
				let isPostConnected = connectedUser.posts?.contains(post.post) == true
				XCTAssertTrue(isPostConnected, "The connected user should be connected to the post", file: file, line: line)
			} else {
				XCTAssertNil(post.user, "There should not be a connected user", file: file, line: line)
			}
		}

		for user in store.users.lastValidData ?? [] {
			if let posts = user.posts {
				for post in posts {
					XCTAssertEqual(post.userID, user.id, "The user ID should match", file: file, line: line)
				}
			} else {
				let matchingPost = store.posts.lastValidData?.first(where: { $0.userID == user.id })
				XCTAssertNil(matchingPost, "There should not be a matching post that is not connected", file: file, line: line)
			}
		}
	}

	func assertCommentsAreConnectedToPosts(file: StaticString = #file, line: UInt = #line) {
		for post in store.posts.lastValidData ?? [] {
			if let comments = post.comments {
				for comment in comments {
					XCTAssertEqual(comment.postID, post.id, "The post ID should match", file: file, line: line)
				}
			} else {
				let matchingComment = store.comments.lastValidData?.first(where: { $0.postID == post.id })
				XCTAssertNil(matchingComment, "There should not be a matching comment that is not connected", file: file, line: line)
			}
		}

		for comment in store.comments.lastValidData ?? [] {
			if let connectedPost = store.posts.lastValidData?.first(where: { $0.id == comment.postID }) {
				XCTAssertEqual(comment.post, connectedPost.post, "There should be a connected post", file: file, line: line)
				let isCommentConnected = connectedPost.comments?.contains(comment.comment) == true
				XCTAssertTrue(isCommentConnected, "The connected post should be connected to the comment", file: file, line: line)
			} else {
				XCTAssertNil(comment.post, "There should not be a connected post", file: file, line: line)
			}
		}
	}
}
