public struct Post: Identifiable, Hashable, Codable {
	public var id: ID
	public var userID: User.ID
	public var title: String
	public var body: String

	public init(
		id: ID,
		userID: User.ID,
		title: String,
		body: String
	) {
		self.id = id
		self.userID = userID
		self.title = title
		self.body = body
	}

	public struct ID: Hashable, Codable {
		public var value: Int

		public init(value: Int) {
			self.value = value
		}
	}
}

extension Post {
	@dynamicMemberLookup
	public struct Connected: Identifiable, Hashable {
		public let post: Post
		public var user: User?
		public var comments: [Comment]?

		public init(post: Post) {
			self.post = post
		}

		public subscript <T> (dynamicMember keyPath: KeyPath<Post, T>) -> T { post[keyPath: keyPath] }

		public var id: Post.ID { post.id }
	}
}
