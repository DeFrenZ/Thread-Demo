import Combine

extension PostsStore {
	static var sample: PostsStore {
		.init(getPosts: {
			Just(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
