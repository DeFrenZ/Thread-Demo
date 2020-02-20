extension Result {
	/// A convenience property for getting the `success` value as an `Optional`
	///
	/// Returns the value on `.success`, `nil` on `.failure`.
	public var value: Success? {
		switch self {
		case .success(let value): return value
		case .failure: return nil
		}
	}

	/// A convenience property for getting the `failure` as an `Optional`
	///
	/// Returns the error on `.failure`, `nil` on `.success`.
	public var error: Failure? {
		switch self {
		case .success: return nil
		case .failure(let error): return error
		}
	}
}
