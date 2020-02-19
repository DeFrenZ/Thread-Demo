public struct Post: Hashable, Codable {
	public var userId: Int
	public var id: Int
	public var title: String
	public var body: String

	public init(
		userId: Int,
		id: Int,
		title: String,
		body: String
	) {
		self.userId = userId
		self.id = id
		self.title = title
		self.body = body
	}
}
