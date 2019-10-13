import Foundation

/// An error that has a message, and the context in which it was created. Useful for non-production purposes as a quick alternative to a more structured `Error`.
struct StringError: Error {
	var message: String
	var file: StaticString
	var line: UInt
	var column: UInt
	var function: StaticString

	init(
		message: String,
		file: StaticString = #file,
		line: UInt = #line,
		column: UInt = #column,
		function: StaticString = #function
	) {
		self.message = message
		self.file = file
		self.line = line
		self.column = column
		self.function = function
	}
}

// Conformance to `LocalizedError` so that when it is converted to an `NSError` it still shows the `message`
extension StringError: LocalizedError {
	// This could include the context as well, but it was deemed unnecessary for now
	var errorDescription: String? { message }
}

/// `throw` a `StringError` with the given `message`, and the context in which this function was called.
///
/// Necessary if you want to throw a `StringError` within an expression. e.g.
/// ```
/// let value = optionalValue ?? `throw`("The value is `nil`")
/// ```
func `throw` <T> (
	_ message: String,
	file: StaticString = #file,
	line: UInt = #line,
	column: UInt = #column,
	function: StaticString = #function
) throws -> T {
	let error = StringError(
		message: message,
		file: file,
		line: line,
		column: column,
		function: function
	)
	throw error
}
