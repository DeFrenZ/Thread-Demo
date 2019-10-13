import Foundation

extension Array where Element == API.User {
	static var samples: [API.User]! {
		guard
			let url = Bundle.main.url(forResource: "users.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode([API.User].self, from: exampleResponse)
	}
}
