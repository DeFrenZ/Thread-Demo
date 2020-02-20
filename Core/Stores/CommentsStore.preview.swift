import Combine

#if ENABLE_SAMPLES
public extension CommentsStore where S == ImmediateScheduler {
	static var sample: CommentsStore {
		.init(
			storage: [:] as MemoryStorage,
			getComments: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	static var sampleLoaded: CommentsStore {
		.init(
			storage: [.comments: [Comment].samples!] as MemoryStorage,
			getComments: {
				Just(.samples)
					.setFailureType(to: FetchError.self)
					.eraseToAnyPublisher()
			},
			scheduler: .shared
		)
	}

	static var sampleLoading: CommentsStore {
		.init(
			storage: [:] as MemoryStorage,
			getComments: { Empty(completeImmediately: false).eraseToAnyPublisher() },
			scheduler: .shared
		)
	}
}
#endif
