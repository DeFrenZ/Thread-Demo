#if canImport(os)
import os
import Foundation

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public struct OSLogHandler {
	private var osLog: OSLog
	private var dso: UnsafeRawPointer
	public var metadata: Logger.Metadata = [:]
	public var logLevel: Logger.Level = .trace

	public init(
		category: String,
		subsystem: String,
		dso: UnsafeRawPointer = #dsohandle
	) {
		self.osLog = .init(subsystem: subsystem, category: category)
		self.dso = dso
	}
}

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogHandler: LogHandler {
	public func log(
		level: Logger.Level,
		message: Logger.Message,
		metadata: Logger.Metadata?,
		file: String, function: String, line: UInt
	) {
		let metadataToLog = self.metadata.merging(metadata ?? [:], uniquingKeysWith: { _, new in new })
		// !!!: Metadata is being appended at the end, but `os_log` potentially clips messages
		// TODO: Use better formatting than `Metadata.description`
		let metadataMessage: Logger.Message = metadataToLog.isEmpty
			? ""
			: """

			METADATA:
			\(metadataToLog)
			"""
		let composedMessage = message + metadataMessage

		os_log(
			level.osLogType,
			dso: dso,
			log: osLog,
			composedMessage.osLogFormatString,
			composedMessage.osLogArguments
		)
	}

	public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
		get { metadata[metadataKey] }
		set { metadata[metadataKey] = newValue }
	}
}

extension Logger.Level {
	@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	var osLogType: OSLogType {
		switch self {
		case .trace, .debug: return .debug
		case .info: return .info
		case .notice: return .default
		case .warning, .error: return .error
		case .critical: return .fault
		}
	}
}

extension Logger.Message {
	var osLogFormatString: String {
		segments.map({ $0.osLogFormatString }).joined()
	}

	var osLogArguments: [CVarArg] {
		segments.compactMap({ $0.osLogArgument })
	}
}

extension Logger.Message.Segment {
	var osLogFormatString: String {
		switch self {
		case .static(let string): return string.description
		case .dynamic(_, let privacy): return "%\(privacy.osLogFormatModifier)s"
		}
	}

	var osLogArgument: CVarArg? {
		switch self {
		case .static: return nil
		case .dynamic(let content, _): return content
		}
	}
}

extension Logger.Message.Segment.Privacy {
	var osLogFormatModifier: String {
		switch self {
		case .public: return "{public}"
		case .private: return "{private}"
		case .default: return ""
		}
	}
}

// MARK: 🐉🐉🐉🐉🐉
import _SwiftOSOverlayShims

// !!!: This is the private implementation of `os_log` in Swift, modified to have `message` as `String` instead of `StaticString`
/// - seealso: https://github.com/apple/swift/blob/14d9011c2be0b877f53383f3eaceed8fc8197dcd/stdlib/public/Darwin/os/os_log.swift#L18-L39
@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
private func os_log(
	_ type: OSLogType,
	dso: UnsafeRawPointer = #dsohandle,
	log: OSLog = .default,
	_ message: String,
	_ args: [CVarArg]
) {
	guard log.isEnabled(type: type) else { return }
	let ra = _swift_os_log_return_address()

	message.withCString({ str in
		withVaList(args) { valist in
			_swift_os_log(dso, ra, log, type, str, valist)
		}
	})
}
#endif
