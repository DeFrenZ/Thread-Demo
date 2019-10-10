public extension API {
	struct Post: Hashable, Codable {
		var userId: Int
		var id: Int
		var title: String
		var body: String
	}
}
