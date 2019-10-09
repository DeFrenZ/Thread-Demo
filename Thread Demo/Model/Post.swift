struct Post: Identifiable {
	var id: ID
	var userID: User.ID
	var title: String
	var body: String

	struct ID: Hashable {
		var value: Int
	}
}
