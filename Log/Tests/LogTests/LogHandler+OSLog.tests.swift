import XCTest
@testable import Log

final class OSLogHandlerTests: XCTestCase {
}

// MARK: - Tests
extension OSLogHandlerTests {
	func test_osLogFormatString_and_osLogArguments() throws {
		let cases: [(line: UInt, input: Logger.Message, expectedOutput: (format: String, arguments: [CVarArg]))] = [
			(#line, "Static", ("Static", [])),
			(#line, "\(private: "Private")", ("%{private}s", ["Private"])),
			(#line, "\(public: "Public")", ("%{public}s", ["Public"])),
			(#line, "Some \(public: "Public") and \(private: "Private")", ("Some %{public}s and %{private}s", ["Public", "Private"])),
			(#line, "This 👈 \(public: "⚠️ SHOULD ⚠️") work 🧑‍🔧 \(private: "with 🅦🅔🅘🅡🅓") 𝒯ℰ𝒳𝒯", ("This 👈 %{public}s work 🧑‍🔧 %{private}s 𝒯ℰ𝒳𝒯", ["⚠️ SHOULD ⚠️", "with 🅦🅔🅘🅡🅓"])),
		]

		for (line, input, expectedOutput) in cases {
			let output = (format: input.osLogFormatString, arguments: input.osLogArguments)
			XCTAssertEqual(output.format, expectedOutput.format, line: line)
			let expectedArgumentsCast = try XCTUnwrap(expectedOutput.arguments as? [String], "Current implementation is restricted to `String` arguments")
			let argumentsCast = try XCTUnwrap(output.arguments as? [String], "Current implementation is restricted to `String` arguments")
			XCTAssertEqual(argumentsCast, expectedArgumentsCast, line: line)
		}
	}
}
