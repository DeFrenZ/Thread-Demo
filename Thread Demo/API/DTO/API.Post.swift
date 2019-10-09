extension API {
	struct Post: Codable {
		var userId: Int
		var id: Int
		var title: String
		var body: String
	}
}
