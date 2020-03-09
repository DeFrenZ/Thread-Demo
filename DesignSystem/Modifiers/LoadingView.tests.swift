import Core
import SwiftUI
import XCTest
@testable import DesignSystem

final class LoadingViewTests: XCTestCase {
}

extension LoadingViewTests {
	func test_accessibility_default() {
		let baseView = Text("Some text")
		let view = LoadingView(showLoader: false, content: { baseView })

		let elements = view.accessibilityNode
			.flattenedElements

		let baseElements = baseView.accessibilityNode
			.flattenedElements
		XCTAssertEqual(elements, baseElements)
	}

	func test_accessibility_loading() {
		let baseView = Text("Some text")
		let view = LoadingView(showLoader: true, content: { baseView })

		let elements = view.accessibilityNode
			.flattenedElements

		XCTAssertEqual(elements, [])
	}
}
