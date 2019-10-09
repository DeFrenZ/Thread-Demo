import XCTest
@testable import Thread_Demo

final class UserTests: XCTestCase {}

// MARK: Tests
extension UserTests {
	func test_givenAnExampleResponse_whenTheResponseIsValid_thenTheParsingSucceeds() throws {
		let url = try Bundle.currentTarget.url(forResource: "users.response", withExtension: "json")
			?? `throw`("File not found")
		let exampleResponse = try Data(contentsOf: url)
		let decoder = JSONDecoder()

		_ = try decoder.decode([User].self, from: exampleResponse)
	}
}
