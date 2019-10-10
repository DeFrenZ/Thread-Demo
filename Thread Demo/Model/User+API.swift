import Foundation
import struct CoreLocation.CLLocationCoordinate2D
import struct CoreLocation.CLLocationDegrees

extension User {
	init(apiModel: API.User) throws {
		guard let urlAddress = URL(string: apiModel.website) else { throw ConversionError(keyPath: \Self.urlAddress, value: apiModel.website) }

		self.init(
			id: .init(value: apiModel.id),
			name: apiModel.name,
			username: apiModel.username,
			emailAddress: apiModel.email,
			postalAddress: try .init(apiModel: apiModel.address),
			phoneNumber: apiModel.phone,
			urlAddress: urlAddress,
			companyDetails: .init(apiModel: apiModel.company)
		)
	}
}

extension User.PostalAddress {
	init(apiModel: API.User.Address) throws {
		self.init(
			street: apiModel.street,
			suite: apiModel.suite,
			city: apiModel.city,
			postalCode: apiModel.zipcode,
			coordinates: try .init(apiModel: apiModel.geo)
		)
	}
}

extension CLLocationCoordinate2D {
	init(apiModel: API.User.Address.GeoLocation) throws {
		guard let latitude = CLLocationDegrees(apiModel.lat) else { throw ConversionError(keyPath: \Self.latitude, value: apiModel.lat) }
		guard let longitude = CLLocationDegrees(apiModel.lng) else { throw ConversionError(keyPath: \Self.longitude, value: apiModel.lng) }

		self.init(
			latitude: latitude,
			longitude: longitude
		)
	}
}

extension User.CompanyDetails {
	init(apiModel: API.User.Company) {
		self.init(
			name: apiModel.name,
			catchPhrase: apiModel.catchPhrase,
			technobabble: apiModel.bs
		)
	}
}
