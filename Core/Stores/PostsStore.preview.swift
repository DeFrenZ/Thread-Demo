import Combine

#if ENABLE_SAMPLES
extension PostsStore where S == ImmediateScheduler {
	public static var sample: PostsStore {
		.init(
			storage: [:] as MemoryStorage,
			getPosts: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	public static var sampleLoaded: PostsStore {
		.init(
			storage: [.posts: [Post].samples!] as MemoryStorage,
			getPosts: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	public static var sampleLoading: PostsStore {
		.init(
			storage: [:] as MemoryStorage,
			getPosts: { Empty(completeImmediately: false).eraseToAnyPublisher() },
			scheduler: .shared
		)
	}
}
#endif
