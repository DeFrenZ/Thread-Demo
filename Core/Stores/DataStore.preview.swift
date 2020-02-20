import Combine

#if ENABLE_SAMPLES
extension DataStore where S == ImmediateScheduler {
	public static var sample: DataStore {
		.init(
			postsStore: .sample,
			usersStore: .sample,
			commentsStore: .sample
		)
	}

	public static var sampleLoaded: DataStore {
		.init(
			postsStore: .sampleLoaded,
			usersStore: .sampleLoaded,
			commentsStore: .sampleLoaded
		)
	}

	public static var sampleLoading: DataStore {
		.init(
			postsStore: .sampleLoading,
			usersStore: .sampleLoading,
			commentsStore: .sampleLoading
		)
	}
}
#endif
