import XCTest
@testable import Thread_Demo

final class PostTests: XCTestCase {}

// MARK: Tests
extension PostTests {
	func test_givenAnExampleResponse_whenTheResponseIsValid_thenTheParsingSucceeds() throws {
		let url = try Bundle.currentTarget.url(forResource: "posts.response", withExtension: "json")
			?? `throw`("File not found")
		let exampleResponse = try Data(contentsOf: url)
		let decoder = JSONDecoder()

		_ = try decoder.decode([Post].self, from: exampleResponse)
	}
}
