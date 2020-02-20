import API
import Combine
import Core
import Foundation

extension DataStore where S == RunLoop {
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

extension API.Client {
	fileprivate func getPostsModels() -> AnyPublisher<[Core.Post], FetchError> {
		getPosts()
			.map({ $0.map(Post.init(apiModel:)) })
			.mapError(FetchError.init(apiError:))
			.eraseToAnyPublisher()
	}

	fileprivate func getUsersModels() -> AnyPublisher<[Core.User], FetchError> {
		getUsers()
			.tryMap({ try $0.map(User.init(apiModel:)) })
			.mapError(FetchError.init(anyError:))
			.eraseToAnyPublisher()
	}

	fileprivate func getCommentsModels() -> AnyPublisher<[Core.Comment], FetchError> {
		getComments()
			.map({ $0.map(Comment.init(apiModel:)) })
			.mapError(FetchError.init(apiError:))
			.eraseToAnyPublisher()
	}
}
