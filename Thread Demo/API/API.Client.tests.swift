import XCTest
@testable import Thread_Demo
import Combine

final class APIClientTests: XCTestCase {
	var stubs: [String: Result<(data: Data, response: URLResponse), URLError>] = [:]
	lazy var client: API.Client = .init(
		baseURL: .testBaseURL,
		performNetworkRequest: { [stubs] request in
			// Arbitrarily chosen `badServerResponse` as a default error for missing stub, as it needs to be an `URLError` to type match
			guard
				let path = request.url?.relativePath,
				let stub = stubs[path]
			else { return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher() }
			return Result.Publisher(stub).eraseToAnyPublisher()
		}
	)
}

// MARK: Tests
extension APIClientTests {
	func test_givenAClient_whenFetchingPosts_andTheResponseIsValid_thenTheDecodedModelIsReturned() {
		let responseBody: [API.Post] = [
			.init(userId: 1, id: 1, title: "Test", body: "This is a test"),
			.init(userId: 1, id: 2, title: "Test 2", body: "This is a test (again)"),
			.init(userId: 2, id: 3, title: "Wow", body: "Such a nice test"),
		]
		stubAPICall(atPath: "/posts", responseBody: responseBody)

		let response = client.getPosts()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingPosts_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody: [TestCodable] = [
			.init(a: 1, b: "a"),
			.init(a: 2, b: "b"),
			.init(a: 3, b: "c"),
		]
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
		let responseBody: [API.User] = [
			.init(id: 1, name: "User 1", username: "user1", email: "user1@test.com", address: .init(street: "1, Test Street", suite: "", city: "Test Town", zipcode: "XXX XXX", geo: .init(lat: "0", lng: "0")), phone: "XXX XXXXXX", website: "http://www.test.com", company: .init(name: "Testy", catchPhrase: "We test it all", bs: "multi-threaded automatic test verification")),
			.init(id: 2, name: "User 2", username: "user2", email: "user2@test.com", address: .init(street: "2, Test Street", suite: "", city: "Test Town", zipcode: "XXX XXX", geo: .init(lat: "0", lng: "0")), phone: "XXX XXXXXX", website: "http://www.test.com", company: .init(name: "Testy", catchPhrase: "We test it all", bs: "multi-threaded automatic test verification")),
			.init(id: 3, name: "User 3", username: "user3", email: "user3@test.com", address: .init(street: "3, Test Street", suite: "", city: "Test Town", zipcode: "XXX XXX", geo: .init(lat: "0", lng: "0")), phone: "XXX XXXXXX", website: "http://www.test.com", company: .init(name: "Testy", catchPhrase: "We test it all", bs: "multi-threaded automatic test verification")),
		]
		stubAPICall(atPath: "/users", responseBody: responseBody)

		let response = client.getUsers()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingUsers_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody: [TestCodable] = [
			.init(a: 1, b: "a"),
			.init(a: 2, b: "b"),
			.init(a: 3, b: "c"),
		]
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
		let responseBody: [API.Comment] = [
			.init(postId: 1, id: 1, name: "User 1", email: "user1@test.com", body: "Well well well"),
			.init(postId: 1, id: 2, name: "User 2", email: "user2@test.com", body: "Let's see what we have here"),
			.init(postId: 2, id: 3, name: "User 1", email: "user1@test.com", body: "It is I! Testy McTestFace!"),
		]
		stubAPICall(atPath: "/comments", responseBody: responseBody)

		let response = client.getComments()
			.awaitSynchronouslyForSingleOutput()

		XCTAssertEqual(response.value, responseBody, "The fetched posts are not equal to the stubbed ones: \(response)")
	}

	func test_givenAClient_whenFetchingComments_andTheResponseDoesntMatch_thenAnErrorIsReturned() {
		let responseBody: [TestCodable] = [
			.init(a: 1, b: "a"),
			.init(a: 2, b: "b"),
			.init(a: 3, b: "c"),
		]
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
