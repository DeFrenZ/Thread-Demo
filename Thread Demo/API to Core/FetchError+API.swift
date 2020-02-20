import API
import Core

extension FetchError {
	init(anyError error: Error) {
		switch error {
		case let apiError as API.Client.APIError:
			self.init(apiError: apiError)
		default:
			self = .badResource
		}
	}

	init(apiError: API.Client.APIError) {
		switch apiError {
		case .invalidURL,
			 .errorResponse(400 ..< 500):
			self = .incorrectFetch
		case .errorResponse(500 ..< 600),
			 .decoding,
			 .unrecognized:
			self = .badResource
		case .network,
			 .notAnHTTPResponse,
			 .errorResponse:
			self = .remoteUnavailable
		}
	}
}
