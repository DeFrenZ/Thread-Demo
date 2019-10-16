import Foundation

struct User: Identifiable, Hashable, Codable {
	var id: ID
	var name: String
	var username: String
	var emailAddress: Email
	var postalAddress: PostalAddress
	var phoneNumber: PhoneNumber
	var urlAddress: URL
	var companyDetails: CompanyDetails

	struct ID: Hashable, Codable {
		var value: Int
	}

	struct PostalAddress: Hashable, Codable {
		var street: String
		var suite: String
		var city: String
		var postalCode: String
		var coordinates: Coordinate
		// ???: Doesn't have `country`?

		struct Coordinate: Hashable, Codable {
			var latitude: Double
			var longitude: Double

			// TODO: Add conversion from `Coordinate` to `CLLocationCoordinate2D`
		}

		// TODO: Add conversion from `PostalAddress` to `CNPostalAddress`
	}

	// TODO: Convert to a proper type that validates its contents
	typealias PhoneNumber = String

	struct CompanyDetails: Hashable, Codable {
		var name: String
		var catchPhrase: String
		var technobabble: String
	}

	// TODO: Add conversion from `User` to `CNContact`
}

extension User {
	@dynamicMemberLookup
	struct Connected: Identifiable, Hashable {
		let user: User
		var posts: [Post]?

		subscript <T> (dynamicMember keyPath: KeyPath<User, T>) -> T { user[keyPath: keyPath] }

		var id: User.ID { user.id }
	}
}
