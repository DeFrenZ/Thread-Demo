import Combine

extension Publisher {
	/// Transform the events from this publisher into `Result`s.
	/// - note: The completion of this publisher will not be propagated, and a failure will be sent as an output of `Result.failure`
	func asResults() -> AnyPublisher<Result<Output, Failure>, Never> {
		map(Result.success)
			.catch({ Just(.failure($0)) })
			.eraseToAnyPublisher()
	}
}
