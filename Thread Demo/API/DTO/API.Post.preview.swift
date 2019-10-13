import Foundation

extension Array where Element == API.Post {
	static var samples: [API.Post]! {
		guard
			let url = Bundle.main.url(forResource: "posts.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode([API.Post].self, from: exampleResponse)
	}
}
