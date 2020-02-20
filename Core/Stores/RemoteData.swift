import Foundation
import Combine

/// A wrapper for data that is retrieved remotely.
///
/// When dealing with remote data there's often an issue with knowing what's the current state, is it currently loading, did it fail, and other similar questions. The state tracked with this wrapper helps dealing with the edge cases.
public struct RemoteData <Data, Failure: Error> {
	/// The last data that was successfully retrieved, and from which source
	public var lastValidData: (data: Data, source: Source)?
	/// The current state of operations around this data
	public var state: State = .idle

	public init(
		lastValidData: (data: Data, source: Source)? = nil,
		state: State = .idle
	) {
		self.lastValidData = lastValidData
		self.state = state
	}

	public typealias State = _RemoteDataState<Failure>
	public typealias Source = _RemoteDataSource
}

extension RemoteData: Equatable where Data: Equatable, Failure: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.lastValidData?.data == rhs.lastValidData?.data
			&& lhs.lastValidData?.source == rhs.lastValidData?.source
			&& lhs.state == rhs.state
	}
}

/// The state of fetching for some remote data
public enum _RemoteDataState <Failure: Error> {
	/// Nothing is being done at the moment. There was either no fetch yet, or the last attempt was successful.
	case idle
	// TODO: Support cancellation
	/// The data is currently being retrieved
	case retrieving
	/// The last attempt at retrieving the data failed
	case failed(Failure)
}

extension _RemoteDataState: Equatable where Failure: Equatable {}

public enum _RemoteDataSource {
	/// The resource was fetched from a remote in a previous session and might be stale
	case storage
	/// The resource was fetched from a remote in this session
	case remote
}

public extension RemoteData {
	mutating func setRemoteValue(to newValue: Result<Data, Failure>) {
		switch newValue {
		case .success(let value):
			lastValidData = (value, .remote)
			state = .idle
		case .failure(let error):
			state = .failed(error)
		}
	}
}

public extension RemoteData {
	func map <T> (_ transform: (Data) throws -> T) rethrows -> RemoteData<T, Failure> {
		guard let lastValidData = self.lastValidData else {
			return .init(lastValidData: nil, state: state)
		}

		let transformedData = try transform(lastValidData.data)
		return .init(lastValidData: (transformedData, lastValidData.source), state: state)
	}
}
