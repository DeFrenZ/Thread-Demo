import Combine

extension Publisher {
	/// Transform the events from this publisher into `Result`s
	/// - note: The completion of this publisher will not be propagated, and an error will be sent as an output of `Result.failure`
	public func asResults() -> AnyPublisher<Result<Output, Failure>, Never> {
		map(Result.success)
			.catch({ Just(.failure($0)) })
			.eraseToAnyPublisher()
	}

	/// Publishes the same events as upstream but ignores any errors
	public func ignoreErrors() -> AnyPublisher<Output, Never> {
		map(Optional.init)
			.replaceError(with: nil)
			.compactMap({ $0 })
			.eraseToAnyPublisher()
	}
}

extension Publisher where Failure == Never {
	/// Assigns a publisher's output to an `Optional` property of an object
	/// - seealso: `Publisher.assign(to:on:)`
	public func assign <Root> (to keyPath: ReferenceWritableKeyPath<Root, Output?>, on object: Root) -> AnyCancellable {
		map(Optional.init)
			.assign(to: keyPath, on: object)
	}
}
