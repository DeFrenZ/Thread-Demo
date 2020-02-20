import Foundation

#if ENABLE_SAMPLES
extension Array where Element == Comment {
	public static var samples: Self! {
		guard
			let url = Bundle.main.url(forResource: "comments.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode(Self.self, from: exampleResponse)
	}
}
#endif
