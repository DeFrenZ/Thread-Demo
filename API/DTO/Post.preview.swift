import Foundation

#if ENABLE_SAMPLES
extension Array where Element == Post {
	public static var samples: Self! {
		guard
			let url = Bundle.main.url(forResource: "posts.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode(Self.self, from: exampleResponse)
	}
}
#endif
