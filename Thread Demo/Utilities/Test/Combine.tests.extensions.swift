import Combine
import XCTest

extension Publisher {
	func awaitSynchronouslyForCompletion(
		timeout: TimeInterval = 1,
		file: StaticString = #file,
		line: UInt = #line
	) -> Result<[Output], Failure> {
		var result: Result<[Output], Failure> = .success([])
		let expectation = XCTestExpectation(description: "The publisher \(self) completes")
		_ = collect().sink(
			receiveCompletion: { completion in
				switch completion {
				case .finished: break
				case .failure(let error): result = .failure(error)
				}
				expectation.fulfill()
			}, receiveValue: { value in
				result = .success(value)
			}
		)

		let waitResult = XCTWaiter.wait(for: [expectation], timeout: timeout)
		if waitResult != .completed {
			XCTFail("The publisher \(self) didn't complete: \(waitResult)", file: file, line: line)
		}
		return result
	}

	func awaitSynchronouslyForSingleOutput(
		timeout: TimeInterval = 1,
		file: StaticString = #file,
		line: UInt = #line
	) -> Result<Output, Failure> {
		let outputsResult = awaitSynchronouslyForCompletion(timeout: timeout, file: file, line: line)
		// Explicit type needed for "complex closure" compiler issue
		let outputResult: Result<Output, Failure> = outputsResult.map { outputs in
			XCTAssertEqual(outputs.count, 1, "The publisher \(self) sent \(outputs.count) values", file: file, line: line)
			// !!!: Not really safe, but no way to generate a completely generic `Result`, and the code will stop at the assertion if it's running with `continueAfterFailure = false`
			return outputs.first!
		}
		return outputResult
	}
}
