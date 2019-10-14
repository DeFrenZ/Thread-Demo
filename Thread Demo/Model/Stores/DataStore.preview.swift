extension DataStore {
	static var sample: DataStore {
		.init(
			postsStore: .sample,
			usersStore: .sample,
			commentsStore: .sample
		)
	}
}
