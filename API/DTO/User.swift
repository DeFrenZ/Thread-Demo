public struct User: Hashable, Codable {
	public var id: Int
	public var name: String
	public var username: String
	public var email: String
	public var address: Address
	public var phone: String
	public var website: String
	public var company: Company

	public init(
		id: Int,
		name: String,
		username: String,
		email: String,
		address: Address,
		phone: String,
		website: String,
		company: Company
	) {
		self.id = id
		self.name = name
		self.username = username
		self.email = email
		self.address = address
		self.phone = phone
		self.website = website
		self.company = company
	}

	public struct Address: Hashable, Codable {
		public var street: String
		public var suite: String
		public var city: String
		public var zipcode: String
		public var geo: GeoLocation

		public init(
			street: String,
			suite: String,
			city: String,
			zipcode: String,
			geo: GeoLocation
		) {
			self.street = street
			self.suite = suite
			self.city = city
			self.zipcode = zipcode
			self.geo = geo
		}

		public struct GeoLocation: Hashable, Codable {
			public var lat: String
			public var lng: String

			public init(
				lat: String,
				lng: String
			) {
				self.lat = lat
				self.lng = lng
			}
		}
	}

	public struct Company: Hashable, Codable {
		public var name: String
		public var catchPhrase: String
		public var bs: String

		public init(
			name: String,
			catchPhrase: String,
			bs: String
		) {
			self.name = name
			self.catchPhrase = catchPhrase
			self.bs = bs
		}
	}
}
