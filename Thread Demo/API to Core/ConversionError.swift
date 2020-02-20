import Foundation

/// An error occurred when converting a value from a DTO to its strongly-typed counterpart in the business model
struct ConversionError <Output, To, From>: Error {
	/// The keypath at which the result of the conversion would've been assigned to
	var keyPath: KeyPath<Output, To>
	/// The original value that had to be converted
	var value: From
}

extension ConversionError: LocalizedError {
	var localizedDescription: String {
		"Couldn't convert value \(value) of type \(From.self) to type \(To.self) for property \(keyPath) of type \(Output.self)"
	}
}
