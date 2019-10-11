import Foundation
import struct CoreLocation.CLLocationCoordinate2D

struct User: Identifiable {
	var id: ID
	var name: String
	var username: String
	var emailAddress: Email
	var postalAddress: PostalAddress
	var phoneNumber: PhoneNumber
	var urlAddress: URL
	var companyDetails: CompanyDetails

	struct ID: Hashable {
		var value: Int
	}

	struct PostalAddress {
		var street: String
		var suite: String
		var city: String
		var postalCode: String
		var coordinates: CLLocationCoordinate2D
		// ???: Doesn't have `country`?

		// TODO: Add conversion from `User.Address` to `CNPostalAddress`
	}

	// TODO: Convert to a proper type that validates its contents
	typealias PhoneNumber = String

	struct CompanyDetails {
		var name: String
		var catchPhrase: String
		var technobabble: String
	}

	// TODO: Add conversion from `User` to `CNContact`
}

extension User {
	final class Connected {
		let user: User
		var posts: [Post.Connected]?

		init(user: User) {
			self.user = user
		}
	}
}
