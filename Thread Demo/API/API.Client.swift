import Foundation
import Combine

public extension API {
	/// An object that can perform API calls
	struct Client {
		// TODO: Increase flexibility over `baseURL`
		/// The base URL used for the URL in the API requests
		let baseURL: URL
		/// The injected behaviour for performing a pure HTTP request
		let performNetworkRequest: PerformNetworkRequest

		init(baseURL: URL = .baseAPIClientURL, performNetworkRequest: @escaping PerformNetworkRequest) {
			self.baseURL = baseURL
			self.performNetworkRequest = performNetworkRequest
		}

		// ???: The response type might be a better match with a `Future` instead of `AnyPublisher`, but it would need some sort of verification that exactly one value comes back from it
		/// The type of functions representing performing an HTTP request
		typealias PerformNetworkRequest = (URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
	}
}

private extension URL {
	static let baseAPIClientURL = URL(string: "http://jsonplaceholder.typicode.com")!
}

// MARK: Convenience `init`
public extension API.Client {
	/// Instantiate a new `Client` with the default `baseURL` and using the given `URLSession` for performing HTTP requests
	///
	/// This is the preferred `init` to use in production contexts. In other cases you might want to use the memberwise `init` and inject a specific `performNetworkRequest`.
	/// - parameters:
	///   - urlSession: The `URLSession` used for performing HTTP requests
	init(urlSession: URLSession = .shared) {
		self.init(performNetworkRequest: {
			// TODO: Make non-sensible parts of the request public logs
			networkLogger.info("Request: \(String(describing: $0))")
			return urlSession.dataTaskPublisher(for: $0)
				.log(.info, on: networkLogger)
				.eraseToAnyPublisher()
		})
	}
}

// MARK: Utilities
extension API.Client {
	// TODO: Increase flexibility over `decoder`
	private static var decoder: JSONDecoder { JSONDecoder() }

	private func getRequest(forPath path: String) -> Result<URLRequest, APIError> {
		guard
			let path = URLComponents(string: path),
			let url = path.url(relativeTo: baseURL)
		else { return .failure(APIError.invalidURL) }

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		return .success(request)
	}

	private func performAPIRequest(_ request: URLRequest) -> AnyPublisher<Data, IntermediateAPIError> {
		performNetworkRequest(request)
			.mapError({ IntermediateAPIError.network($0) })
			.tryMap({ dataAndResponse in
				guard let httpResponse = dataAndResponse.response as? HTTPURLResponse else { throw IntermediateAPIError.notAnHTTPResponse }
				guard (200 ..< 300).contains(httpResponse.statusCode) else { throw IntermediateAPIError.errorResponse(httpStatusCode: httpResponse.statusCode) }
				return dataAndResponse.data
			})
			// !!!: Safe because `mapError` and `tryMap` above make sure that only `IntermediateAPIError`s go through. Could use a more type-safe API to make this unnecessary
			.mapError({ $0 as! IntermediateAPIError })
			.eraseToAnyPublisher()
	}

	private func performGET <Output: Decodable> (
		request: Result<URLRequest, APIError>,
		decodingTo outputType: Output.Type
	) -> AnyPublisher<Output, APIError> {
		switch request {
		case .success(let request):
			return performAPIRequest(request)
				.decode(type: Output.self, decoder: Self.decoder)
				.mapError({ error in
					switch error {
					case let intermediateError as IntermediateAPIError:
						switch intermediateError {
						case .network(let networkError): return .network(networkError)
						case .notAnHTTPResponse: return .notAnHTTPResponse
						case .errorResponse(let httpStatusCode): return .errorResponse(httpStatusCode: httpStatusCode)
						}
					case let decodingError as DecodingError:
						return .decoding(decodingError)
					default:
						// This can happen if `decoder` throws an error that it's not `DecodingError`.
						// In a decoder following the `Codable` semantics, this should happen only if a `Decodable` throws itself an error inside `init(from:)`.
						return .unrecognized(error)
					}
				})
				.log(.info, on: logger)
				.eraseToAnyPublisher()
		case .failure(let error):
			return Fail(error: error)
				.logFailure(.error, on: logger)
				.eraseToAnyPublisher()
		}
	}

	private enum IntermediateAPIError: Error {
		case network(URLError)
		case notAnHTTPResponse
		case errorResponse(httpStatusCode: Int)
	}

	/// An error incurred while performing an API call
	public enum APIError: Error {
		// ???: It might be worth not exposing this error at all, as it doesn't make much sense from the public API point of view. This shouldn't happen anyway as the URLs are static, and with the introduction of arguments these should be type-safe and sanitised.
		/// The generated URL for the HTTP request wasn't valid
		case invalidURL
		/// An error occurred during the HTTP request
		case network(URLError)
		/// The HTTP response is not valid
		case notAnHTTPResponse
		/// The HTTP response has a non successful status code
		case errorResponse(httpStatusCode: Int)
		/// The decoding of the returned body failed
		case decoding(DecodingError)
		/// An error occurred that is not explicitly handled
		case unrecognized(Error)
	}
}

// MARK: Endpoints
// Ideally these shouldn't be function calls, but a more declarative interface where you define a type for each endpoint and use those from the call-site, which scales much better than this approach. For this restricted case it's not worth setting that up, though
public extension API.Client {
	/// Perform an API call to retrieve all the posts
	func getPosts() -> AnyPublisher<[API.Post], APIError> {
		logger.info("GET posts")
		let request = getRequest(forPath: "posts")
		return performGET(request: request, decodingTo: [API.Post].self)
	}

	/// Perform an API call to retrieve all the users
	func getUsers() -> AnyPublisher<[API.User], APIError> {
		logger.info("GET users")
		let request = getRequest(forPath: "users")
		return performGET(request: request, decodingTo: [API.User].self)
	}

	/// Perform an API call to retrieve all the comments
	func getComments() -> AnyPublisher<[API.Comment], APIError> {
		logger.info("GET comments")
		let request = getRequest(forPath: "comments")
		return performGET(request: request, decodingTo: [API.Comment].self)
	}
}

// MARK: - Logger
private let logger: Logger = .init(label: "API")
private let networkLogger = Logger(label: "Network")
