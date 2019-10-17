extension DataStore {
	static var sample: DataStore {
		.init(
			postsStore: .sample,
			usersStore: .sample,
			commentsStore: .sample
		)
	}

	static var sampleLoading: DataStore {
		.init(
			postsStore: .sampleLoading,
			usersStore: .sampleLoading,
			commentsStore: .sampleLoading
		)
	}
}
