import XCTest
@testable import API

final class PostTests: XCTestCase {}

// MARK: Tests
extension PostTests {
	func test_givenAnExampleResponse_whenTheResponseIsValid_thenTheParsingSucceeds() throws {
		let url = try Bundle.currentTarget.url(forResource: "posts.response", withExtension: "json")
			?? `throw`("File not found")
		let exampleResponse = try Data(contentsOf: url)
		let decoder = JSONDecoder()

		XCTAssertNoThrow(try decoder.decode([Post].self, from: exampleResponse), "The sample data didn't decode successfully")
	}
}
