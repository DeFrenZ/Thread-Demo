import Core
import XCTest
@testable import Frontend

final class PostCellTests: XCTestCase {
}

extension PostCellTests {
	func test_accessibility_default() {
		let view = PostCell(post: .sample)

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 1
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, .staticText)
		XCTAssertEqual(elements[0].label, "Post by Leanne Graham: sunt aut facere repellat provident occaecati excepturi optio reprehenderit. Has 5 comments")
	}

	func test_accessibility_hiddenComments() {
		let view = PostCell(post: .sample, showNumberOfComments: false)

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 1
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, .staticText)
		XCTAssertEqual(elements[0].label, "Post by Leanne Graham: sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
	}
}
