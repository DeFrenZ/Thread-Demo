import Combine

extension PostsStore {
	static var sample: PostsStore {
		.init(getPosts: {
			Just<[Post]>(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}
