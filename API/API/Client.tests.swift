import Combine
import XCTest
@testable import API

final class APIClientTests: XCTestCase {
	var stubs: [String: Result<(data: Data, response: URLResponse), URLError>] = [:]
	// `lazy` to allow capture of other properties
	lazy var client: Client = .init(
		baseURL: .testBaseURL,
		performNetworkRequest: { [stubs] request in
			guard
				let path = request.url?.relativePath,
				let stub = stubs[path]
			// Arbitrarily chosen `badServerResponse` as a default error for missing stub, as it needs to be an `URLError` to type match
			else { return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher() }

			return Result.Publisher(stub).eraseToAnyPublisher()
		}
	)
}

// MARK: Tests
extension APIClientTests {
	func test_givenAClient_whenFetchingPosts_andTheResponseIsValid_thenTheDecodedModelIsReturned() {
		let responseBody = [Post].samples
		stubAPICall(atPath: "/posts", responseBody: responseBody)

		let response = client.getPosts()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingPosts_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody = [TestCodable].samples
		stubAPICall(atPath: "/posts", responseBody: responseBody)

		let response = client.getPosts()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}

	func test_givenAClient_whenFetchingPosts_andTheRequestFails_thenAnErrorIsReturned() {
		stubs["/posts"] = .failure(.init(.badServerResponse))

		let response = client.getPosts()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}

	func test_givenAClient_whenFetchingUsers_andTheResponseIsValid_thenTheDecodedModelIsReturned() {
		let responseBody = [User].samples
		stubAPICall(atPath: "/users", responseBody: responseBody)

		let response = client.getUsers()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingUsers_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody = [TestCodable].samples
		stubAPICall(atPath: "/users", responseBody: responseBody)

		let response = client.getUsers()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}

	func test_givenAClient_whenFetchingUsers_andTheRequestFails_thenAnErrorIsReturned() {
		stubs["/users"] = .failure(.init(.badServerResponse))

		let response = client.getUsers()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}

	func test_givenAClient_whenFetchingComments_andTheResponseIsValid_thenTheDecodedModelIsReturned() {
		let responseBody = [Comment].samples
		stubAPICall(atPath: "/comments", responseBody: responseBody)

		let response = client.getComments()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingComments_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody = [TestCodable].samples
		stubAPICall(atPath: "/comments", responseBody: responseBody)

		let response = client.getComments()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}

	func test_givenAClient_whenFetchingComments_andTheRequestFails_thenAnErrorIsReturned() {
		stubs["/posts"] = .failure(.init(.badServerResponse))

		let response = client.getComments()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertNotNil(response.error, "The fetch should result in error: \(response)")
	}
}

// MARK: Utilities
private extension APIClientTests {
	func stubAPICall <T: Encodable> (
		atPath path: String,
		responseBody body: T,
		file: StaticString = #file,
		line: UInt = #line
	) {
		let data: Data
		do {
			// !!!: This should match `API.Client.decoder`
			let encoder = JSONEncoder()
			data = try encoder.encode(body)
		} catch {
			XCTFail("Failed to encode the given body: \(error)", file: file, line: line)
			return
		}

		guard let url = URLComponents(string: path)?.url(relativeTo: .testBaseURL) else {
			XCTFail("Failed to compose the request URL for path: \(path)", file: file, line: line)
			return
		}

		guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil) else {
			XCTFail("Failed to create response for stub at URL: \(url)", file: file, line: line)
			return
		}

		stubs[path] = .success((data: data, response: response))
	}
}

private extension URL {
	static let testBaseURL = URL(string: "http://unit.test.com")!
}

private struct TestCodable: Hashable, Codable {
	var a: Int
	var b: String
}

extension Array where Element == TestCodable {
	static let samples: Self = [
		.init(a: 1, b: "a"),
		.init(a: 2, b: "b"),
		.init(a: 3, b: "c"),
	]
}
