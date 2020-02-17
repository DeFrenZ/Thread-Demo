import Combine

extension PostsStore where S == ImmediateScheduler {
	static var sample: PostsStore {
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

	static var sampleLoaded: PostsStore {
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

	static var sampleLoading: PostsStore {
		.init(
			storage: [:] as MemoryStorage,
			getPosts: { Empty(completeImmediately: false).eraseToAnyPublisher() },
			scheduler: .shared
		)
	}
}
