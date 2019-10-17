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
	/// The source from which the data was retrieved
	var source: Source = .remote

	typealias State = _RemoteDataState<Failure>
	typealias Source = _RemoteDataSource
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

enum _RemoteDataSource {
	/// The resource was fetched from a remote in a previous session and might be stale
	case storage
	/// The resource was fetched from a remote in this session
	case remote
}

extension RemoteData {
	mutating func setValue(to newValue: Result<Data, Failure>, source newSource: Source) {
		switch newValue {
		case .success(let value):
			lastValidData = value
			state = .idle
			source = newSource
		case .failure(let error):
			state = .failed(error)
		}
	}
}

extension RemoteData {
	func map <T> (_ transform: (Data) throws -> T) rethrows -> RemoteData<T, Failure> {
		guard let lastValidData = self.lastValidData else {
			return .init(lastValidData: nil, state: state)
		}

		let transformedData = try transform(lastValidData)
		return .init(lastValidData: transformedData, state: state)
	}
}
