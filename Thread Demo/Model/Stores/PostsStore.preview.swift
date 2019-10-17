import Combine

extension PostsStore {
	static var sample: PostsStore {
		.init(
			storage: [:] as MemoryStorage,
			getPosts: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			}
		)
	}

	static var sampleLoading: PostsStore {
		.init(
			storage: [:] as MemoryStorage,
			getPosts: { Empty(completeImmediately: false).eraseToAnyPublisher() }
		)
	}
}
