#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
	public typealias Log<T> = HandleEvents<T> where T: Publisher
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
	public func log(_ level: Logger.Level, on logger: Logger) -> Publishers.Log<Self> {
		handleEvents(
			receiveSubscription: { logger.log(level: level, Self.buildDefaultSubscriptionMessage($0)) },
			receiveOutput: { logger.log(level: level, Self.buildDefaultOutputMessage($0)) },
			receiveCompletion: { logger.log(level: level, Self.buildDefaultCompletionMessage($0)) },
			receiveCancel: { logger.log(level: level, Self.buildDefaultCancelMessage()) },
			receiveRequest: { logger.log(level: level, Self.buildDefaultRequestMessage($0)) }
		)
	}

	public func logOutputs(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping (Output) -> Logger.Message = Self.buildDefaultOutputMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveOutput: { logger.log(level: level, buildMessage($0)) })
	}

	public func logCompletion(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping (Subscribers.Completion<Failure>) -> Logger.Message = Self.buildDefaultCompletionMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveCompletion: { logger.log(level: level, buildMessage($0)) })
	}

	public func logFinish(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping () -> Logger.Message = Self.buildDefaultFinishMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveCompletion: {
			switch $0 {
			case .finished: logger.log(level: level, buildMessage())
			case .failure: break
			}
		})
	}

	public func logFailure(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping (Failure) -> Logger.Message = Self.buildDefaultFailureMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveCompletion: {
			switch $0 {
			case .finished: break
			case .failure(let error): logger.log(level: level, buildMessage(error))
			}
		})
	}
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
	public static func buildDefaultSubscriptionMessage(_ subscription: Subscription) -> Logger.Message {
		"Received subscription: \(String(describing: subscription))"
	}

	public static func buildDefaultOutputMessage(_ output: Output) -> Logger.Message {
		"Received output: \(String(describing: output))"
	}

	public static func buildDefaultCompletionMessage(_ completion: Subscribers.Completion<Failure>) -> Logger.Message {
		switch completion {
		case .finished: return buildDefaultFinishMessage()
		case .failure(let error): return buildDefaultFailureMessage(error)
		}
	}

	public static func buildDefaultFinishMessage() -> Logger.Message {
		"Received completion"
	}

	public static func buildDefaultFailureMessage(_ error: Failure) -> Logger.Message {
		"Received failure: \(String(describing: error))"
	}

	public static func buildDefaultCancelMessage() -> Logger.Message {
		"Received cancel"
	}

	public static func buildDefaultRequestMessage(_ demand: Subscribers.Demand) -> Logger.Message {
		"Received demand: \(String(describing: demand))"
	}
}
#endif
