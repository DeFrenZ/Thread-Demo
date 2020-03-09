import Core
import SwiftUI
import XCTest
@testable import DesignSystem

final class BannerTests: XCTestCase {
}

extension BannerTests {
	func test_accessibility_default() {
		let baseView = Text("Some text")
		let view = Banner(action: {}, label: { baseView })

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 1
		else { return XCTFail("Unexpected elements count: \(elements)") }
		let baseElements = baseView.accessibilityNode
			.flattenedElements
		guard baseElements.count == 1
		else { return XCTFail("Unexpected base elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, baseElements[0].traits.union(.button))
		XCTAssertEqual(elements[0].label, baseElements[0].label)
		XCTAssertEqual(elements[0].hint, baseElements[0].hint)
	}
}
