import XCTest
@testable import Thread_Demo
import Combine

final class DataStoreTests: XCTestCase {
	var postsSubject: PassthroughSubject<[Post], FetchError>!
	lazy var postsStore: PostsStore = .init(getPosts: {
		self.postsSubject = .init()
		return self.postsSubject
			// Add buffer so that values sent before the subscription activates still go through
			.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
			.eraseToAnyPublisher()
	})
	var usersSubject: PassthroughSubject<[User], FetchError>!
	lazy var usersStore: UsersStore = .init(getUsers: {
		self.usersSubject = .init()
		return self.usersSubject
			// Add buffer so that values sent before the subscription activates still go through
			.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
			.eraseToAnyPublisher()
	})
	var commentsSubject: PassthroughSubject<[Comment], FetchError>!
	// `lazy` to allow capture of other properties
	lazy var commentsStore: CommentsStore = .init(getComments: {
		self.commentsSubject = .init()
		return self.commentsSubject
			// Add buffer so that values sent before the subscription activates still go through
			.buffer(size: .max, prefetch: .byRequest, whenFull: .dropNewest)
			.eraseToAnyPublisher()
	})
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

		for post in postsStore.posts.lastValidData ?? [] {
			if let connectedUser = usersStore.users.lastValidData?.first(where: { $0.id == post.userID }) {
				XCTAssert(post.user === connectedUser, "There should be a connected user")
				let isPostConnected = connectedUser.posts?.contains(where: { $0 === post }) == true
				XCTAssertTrue(isPostConnected, "The connected user should be connected to the post")
			} else {
				XCTAssertNil(post.user, "There should not be a connected user")
			}

			if let comments = post.comments {
				for comment in comments {
					XCTAssertEqual(comment.postID, post.id, "The post ID should match")
					XCTAssert(comment.post === post, "The post should be connected")
				}
			} else {
				let matchingComment = commentsStore.comments.lastValidData?.first(where: { $0.postID == post.id })
				XCTAssertNil(matchingComment, "There should not be a matching comment that is not connected")
			}
		}

		for user in usersStore.users.lastValidData ?? [] {
			if let posts = user.posts {
				for post in posts {
					XCTAssertEqual(post.userID, user.id, "The user ID should match")
					XCTAssert(post.user === user, "The user should be connected")
				}
			} else {
				let matchingPost = postsStore.posts.lastValidData?.first(where: { $0.userID == user.id })
				XCTAssertNil(matchingPost, "There should not be a matching post that is not connected")
			}
		}

		for comment in commentsStore.comments.lastValidData ?? [] {
			if let connectedPost = postsStore.posts.lastValidData?.first(where: { $0.id == comment.postID }) {
				XCTAssert(comment.post === connectedPost, "There should be a connected post")
				let isCommentConnected = connectedPost.comments?.contains(where: { $0 === comment }) == true
				XCTAssertTrue(isCommentConnected, "The connected post should be connected to the comment")
			} else {
				XCTAssertNil(comment.post, "There should not be a connected post")
			}
		}
	}
}
