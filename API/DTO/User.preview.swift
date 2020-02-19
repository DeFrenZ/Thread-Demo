import Foundation

extension Array where Element == User {
	static var samples: Self! {
		guard
			let url = Bundle.main.url(forResource: "users.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode(Self.self, from: exampleResponse)
	}
}
