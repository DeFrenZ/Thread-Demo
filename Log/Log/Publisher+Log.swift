#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
	typealias Log<T> = HandleEvents<T> where T: Publisher
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
	func log(_ level: Logger.Level, on logger: Logger) -> Publishers.Log<Self> {
		handleEvents(
			receiveSubscription: { logger.log(level: level, Self.buildDefaultSubscriptionMessage($0)) },
			receiveOutput: { logger.log(level: level, Self.buildDefaultOutputMessage($0)) },
			receiveCompletion: { logger.log(level: level, Self.buildDefaultCompletionMessage($0)) },
			receiveCancel: { logger.log(level: level, Self.buildDefaultCancelMessage()) },
			receiveRequest: { logger.log(level: level, Self.buildDefaultRequestMessage($0)) }
		)
	}

	func logOutputs(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping (Output) -> Logger.Message = Self.buildDefaultOutputMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveOutput: { logger.log(level: level, buildMessage($0)) })
	}

	func logCompletion(
		_ level: Logger.Level,
		on logger: Logger,
		message buildMessage: @escaping (Subscribers.Completion<Failure>) -> Logger.Message = Self.buildDefaultCompletionMessage
	) -> Publishers.Log<Self> {
		handleEvents(receiveCompletion: { logger.log(level: level, buildMessage($0)) })
	}

	func logFinish(
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

	func logFailure(
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
public extension Publisher {
	static func buildDefaultSubscriptionMessage(_ subscription: Subscription) -> Logger.Message {
		"Received subscription: \(String(describing: subscription))"
	}

	static func buildDefaultOutputMessage(_ output: Output) -> Logger.Message {
		"Received output: \(String(describing: output))"
	}

	static func buildDefaultCompletionMessage(_ completion: Subscribers.Completion<Failure>) -> Logger.Message {
		switch completion {
		case .finished: return buildDefaultFinishMessage()
		case .failure(let error): return buildDefaultFailureMessage(error)
		}
	}

	static func buildDefaultFinishMessage() -> Logger.Message {
		"Received completion"
	}

	static func buildDefaultFailureMessage(_ error: Failure) -> Logger.Message {
		"Received failure: \(String(describing: error))"
	}

	static func buildDefaultCancelMessage() -> Logger.Message {
		"Received cancel"
	}

	static func buildDefaultRequestMessage(_ demand: Subscribers.Demand) -> Logger.Message {
		"Received demand: \(String(describing: demand))"
	}
}
#endif
