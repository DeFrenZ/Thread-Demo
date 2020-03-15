import Core
import SwiftUI
import XCTest
@testable import DesignSystem

final class BannerViewTests: XCTestCase {
}

extension BannerViewTests {
	func test_accessibility_default_noAction() {
		let baseView = Text("Some text")
		let view = BannerView(
			message: "Some Header",
			content: { baseView }
		)

		let elements = view.accessibilityNode
			.flattenedElements

		let baseElements = baseView.accessibilityNode
			.flattenedElements
		guard elements.count == 2
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, .staticText)
		XCTAssertEqual(elements[1].label, "Some text")
		guard baseElements.count == 1
		else { return XCTFail("Unexpected base elements count: \(elements)") }
		XCTAssertEqual(elements[1].traits, baseElements[0].traits)
		XCTAssertEqual(elements[1].label, baseElements[0].label)
		XCTAssertEqual(elements[1].hint, baseElements[0].hint)
	}

	func test_accessibility_default_withAction() {
		let baseView = Text("Some text")
		let view = BannerView(
			message: "Some Header",
			action: {},
			content: { baseView }
		)

		let elements = view.accessibilityNode
			.flattenedElements

		let baseElements = baseView.accessibilityNode
			.flattenedElements
		guard elements.count == 2
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, [.staticText, .button])
		XCTAssertEqual(elements[1].label, "Some text")
		guard baseElements.count == 1
		else { return XCTFail("Unexpected base elements count: \(elements)") }
		XCTAssertEqual(elements[1].traits, baseElements[0].traits)
		XCTAssertEqual(elements[1].label, baseElements[0].label)
		XCTAssertEqual(elements[1].hint, baseElements[0].hint)
	}

	func test_accessibility_hidden() {
		let baseView = Text("Some text")
		let view = BannerView(
			message: nil,
			content: { baseView }
		)

		let elements = view.accessibilityNode
			.flattenedElements

		let baseElements = baseView.accessibilityNode
			.flattenedElements
		XCTAssertEqual(elements, baseElements)
	}
}
