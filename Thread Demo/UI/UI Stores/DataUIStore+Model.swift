extension DataUIStore {
	convenience init(_ dataStore: DataStore) {
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
