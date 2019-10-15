import Foundation
import Combine

/// A wrapper for data that is retrieved remotely.
///
/// When dealing with remote data there's often an issue with knowing what's the current state, is it currently loading, did it fail, and other similar questions. The state tracked with this wrapper helps dealing with the edge cases.
struct RemoteData <Data, Failure: Error> {
	/// The last data that was successfully retrieved
	var lastValidData: Data?
	/// The current state of operations around this data
	var state: State = .idle

	typealias State = _RemoteDataState<Failure>
}

extension RemoteData: Equatable where Data: Equatable, Failure: Equatable {}

/// The state of fetching for some remote data
enum _RemoteDataState <Failure: Error> {
	/// Nothing is being done at the moment. There was either no fetch yet, or the last attempt was successful.
	case idle
	// TODO: Support cancellation
	/// The data is currently being retrieved
	case retrieving
	/// The last attempt at retrieving the data failed
	case failed(Failure)
}

extension _RemoteDataState: Equatable where Failure: Equatable {}

extension RemoteData {
	func map <T> (_ transform: (Data) throws -> T) rethrows -> RemoteData<T, Failure> {
		guard let lastValidData = self.lastValidData else {
			return .init(lastValidData: nil, state: state)
		}

		let transformedData = try transform(lastValidData)
		return .init(lastValidData: transformedData, state: state)
	}
}
