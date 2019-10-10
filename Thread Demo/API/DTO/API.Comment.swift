public extension API {
	struct Comment: Hashable, Codable {
		var postId: Int
		var id: Int
		var name: String
		var email: String
		var body: String
	}
}
