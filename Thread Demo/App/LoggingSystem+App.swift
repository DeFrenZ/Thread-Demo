import Foundation
import Log

extension LoggingSystem {
	static func bootstrap() {
		bootstrap(OSLogHandler.factory(label:))
	}
}

extension OSLogHandler {
	fileprivate static func factory(label: String) -> OSLogHandler {
		.init(
			category: label,
			subsystem: Bundle.main.bundleIdentifier ?? "???"
		)
	}
}

// MARK: - Logger
extension Logger {
	static let generic: Logger = .init(label: "􀌵 Generic")
}
