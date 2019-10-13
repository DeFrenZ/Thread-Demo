import Foundation

extension Array where Element == API.Comment {
	static var samples: [API.Comment]! {
		guard
			let url = Bundle.main.url(forResource: "comments.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode([API.Comment].self, from: exampleResponse)
	}
}
