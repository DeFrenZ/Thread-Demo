import Combine

extension DataStore where S == ImmediateScheduler {
	static var sample: DataStore {
		.init(
			postsStore: .sample,
			usersStore: .sample,
			commentsStore: .sample
		)
	}

	static var sampleLoaded: DataStore {
		.init(
			postsStore: .sampleLoaded,
			usersStore: .sampleLoaded,
			commentsStore: .sampleLoaded
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
