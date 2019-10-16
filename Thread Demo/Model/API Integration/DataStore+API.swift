import Foundation
import Combine

extension DataStore {
	convenience init(
		storage: Storage = UserDefaults.standard,
		api: API.Client
	) {
		self.init(
			postsStore: .init(storage: storage, getPosts: api.getPostsModels),
			usersStore: .init(storage: storage, getUsers: api.getUsersModels),
			commentsStore: .init(storage: storage, getComments: api.getCommentsModels)
		)
	}
}

private extension API.Client {
	func getPostsModels() -> AnyPublisher<[Post], FetchError> {
		getPosts()
			.map({ $0.map(Post.init(apiModel:)) })
			.mapError(FetchError.init(apiError:))
			.eraseToAnyPublisher()
	}

	func getUsersModels() -> AnyPublisher<[User], FetchError> {
		getUsers()
			.tryMap({ try $0.map(User.init(apiModel:)) })
			.mapError(FetchError.init(anyError:))
			.eraseToAnyPublisher()
	}

	func getCommentsModels() -> AnyPublisher<[Comment], FetchError> {
		getComments()
			.map({ $0.map(Comment.init(apiModel:)) })
			.mapError(FetchError.init(apiError:))
			.eraseToAnyPublisher()
	}
}

extension FetchError {
	init(anyError error: Error) {
		switch error {
		case let apiError as API.Client.APIError:
			self.init(apiError: apiError)
		default:
			self = .badResource
		}
	}

	init(apiError: API.Client.APIError) {
		switch apiError {
		case .invalidURL,
			 .errorResponse(400 ..< 500):
			self = .incorrectFetch
		case .errorResponse(500 ..< 600),
			 .decoding,
			 .unrecognized:
			self = .badResource
		case .network,
			 .notAnHTTPResponse,
			 .errorResponse:
			self = .remoteUnavailable
		}
	}
}
