import Core
import XCTest
@testable import Frontend

final class CommentCellTests: XCTestCase {
}

extension CommentCellTests {
	func test_accessibility_default() {
		let view = CommentCell(comment: .sample)

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 1
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, .staticText)
		XCTAssertEqual(elements[0].label, "Comment by id labore ex et quam laborum: laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
	}
}
