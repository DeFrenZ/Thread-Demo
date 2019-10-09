import XCTest
@testable import Thread_Demo

final class CommentTests: XCTestCase {}

// MARK: Tests
extension CommentTests {
	func test_givenAnExampleResponse_whenTheResponseIsValid_thenTheParsingSucceeds() throws {
		let url = try Bundle.currentTarget.url(forResource: "comments.response", withExtension: "json")
			?? `throw`("File not found")
		let exampleResponse = try Data(contentsOf: url)
		let decoder = JSONDecoder()

		_ = try decoder.decode([API.Comment].self, from: exampleResponse)
	}
}
