public extension API {
	struct User: Hashable, Codable {
		var id: Int
		var name: String
		var username: String
		var email: String
		var address: Address
		var phone: String
		var website: String
		var company: Company

		struct Address: Hashable, Codable {
			var street: String
			var suite: String
			var city: String
			var zipcode: String
			var geo: GeoLocation

			struct GeoLocation: Hashable, Codable {
				var lat: String
				var lng: String
			}
		}

		struct Company: Hashable, Codable {
			var name: String
			var catchPhrase: String
			var bs: String
		}
	}
}
