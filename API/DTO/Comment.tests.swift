import XCTest
@testable import API

final class CommentTests: XCTestCase {}

// MARK: Tests
extension CommentTests {
	func test_givenAnExampleResponse_whenTheResponseIsValid_thenTheParsingSucceeds() throws {
		let url = try Bundle.currentTarget.url(forResource: "comments.response", withExtension: "json")
			?? `throw`("File not found")
		let exampleResponse = try Data(contentsOf: url)
		let decoder = JSONDecoder()

		XCTAssertNoThrow(try decoder.decode([Comment].self, from: exampleResponse), "The sample data didn't decode successfully")
	}
}
