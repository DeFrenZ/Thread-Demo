import Combine
import Core

public extension DataUIStore {
	convenience init <S: Scheduler> (_ dataStore: DataStore<S>) {
		self.init(
			initialPosts: dataStore.posts,
			posts: dataStore.$posts.eraseToAnyPublisher(),
			initialUsers: dataStore.users,
			users: dataStore.$users.eraseToAnyPublisher(),
			initialComments: dataStore.comments,
			comments: dataStore.$comments.eraseToAnyPublisher(),
			fetchAll: dataStore.fetchAll
		)
	}
}
