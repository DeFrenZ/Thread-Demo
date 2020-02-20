public struct Comment: Identifiable, Hashable, Codable {
	public var id: ID
	public var postID: Post.ID
	public var authorName: String
	public var authorEmail: Email
	public var body: String

	public init(
		id: ID,
		postID: Post.ID,
		authorName: String,
		authorEmail: Email,
		body: String
	) {
		self.id = id
		self.postID = postID
		self.authorName = authorName
		self.authorEmail = authorEmail
		self.body = body
	}

	public struct ID: Hashable, Codable {
		public var value: Int

		public init(value: Int) {
			self.value = value
		}
	}
}

extension Comment {
	@dynamicMemberLookup
	public struct Connected: Identifiable, Hashable {
		public let comment: Comment
		public var post: Post?

		public init(comment: Comment) {
			self.comment = comment
		}

		public subscript <T> (dynamicMember keyPath: KeyPath<Comment, T>) -> T { comment[keyPath: keyPath] }

		public var id: Comment.ID { comment.id }
	}
}
