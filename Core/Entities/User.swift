import Foundation

public struct User: Identifiable, Hashable, Codable {
	public var id: ID
	public var name: String
	public var username: String
	public var emailAddress: Email
	public var postalAddress: PostalAddress
	public var phoneNumber: PhoneNumber
	public var urlAddress: URL
	public var companyDetails: CompanyDetails

	public init(
		id: ID,
		name: String,
		username: String,
		emailAddress: Email,
		postalAddress: PostalAddress,
		phoneNumber: PhoneNumber,
		urlAddress: URL,
		companyDetails: CompanyDetails
	) {
		self.id = id
		self.name = name
		self.username = username
		self.emailAddress = emailAddress
		self.postalAddress = postalAddress
		self.phoneNumber = phoneNumber
		self.urlAddress = urlAddress
		self.companyDetails = companyDetails
	}

	public struct ID: Hashable, Codable {
		public var value: Int

		public init(value: Int) {
			self.value = value
		}
	}

	public struct PostalAddress: Hashable, Codable {
		public var street: String
		public var suite: String
		public var city: String
		public var postalCode: String
		public var coordinates: Coordinate
		// ???: Doesn't have `country`?

		public init(
			street: String,
			suite: String,
			city: String,
			postalCode: String,
			coordinates: Coordinate
		) {
			self.street = street
			self.suite = suite
			self.city = city
			self.postalCode = postalCode
			self.coordinates = coordinates
		}

		public struct Coordinate: Hashable, Codable {
			public var latitude: Double
			public var longitude: Double

			public init(
				latitude: Double,
				longitude: Double
			) {
				self.latitude = latitude
				self.longitude = longitude
			}

			// TODO: Add conversion from `Coordinate` to `CLLocationCoordinate2D`
		}

		// TODO: Add conversion from `PostalAddress` to `CNPostalAddress`
	}

	// TODO: Convert to a proper type that validates its contents
	public typealias PhoneNumber = String

	public struct CompanyDetails: Hashable, Codable {
		public var name: String
		public var catchPhrase: String
		public var technobabble: String

		public init(
			name: String,
			catchPhrase: String,
			technobabble: String
		) {
			self.name = name
			self.catchPhrase = catchPhrase
			self.technobabble = technobabble
		}
	}

	// TODO: Add conversion from `User` to `CNContact`
}

extension User {
	@dynamicMemberLookup
	public struct Connected: Identifiable, Hashable {
		public let user: User
		public var posts: [Post]?

		public init(user: User) {
			self.user = user
		}

		public subscript <T> (dynamicMember keyPath: KeyPath<User, T>) -> T { user[keyPath: keyPath] }

		public var id: User.ID { user.id }
	}
}
