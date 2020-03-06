import Core
import XCTest
@testable import Frontend

final class PostListViewTests: XCTestCase {
}

extension PostListViewTests {
	func test_accessibility_default() {
		let store = DataUIStore.sampleLoaded
		store.fetchAll(.storageOnly)
		let view = PostsList()
			.environmentObject(store)
			.frame(width: 300, height: 10_000)

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 100
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, [.staticText, .button])
		XCTAssertEqual(elements[0].label, "Post by Leanne Graham: sunt aut facere repellat provident occaecati excepturi optio reprehenderit. Has 5 comments")
		XCTAssertEqual(elements[0].hint, "Shows comments.")
		XCTAssertEqual(elements[1].traits, [.staticText, .button])
		XCTAssertEqual(elements[1].label, "Post by Leanne Graham: qui est esse. Has 5 comments")
		XCTAssertEqual(elements[1].hint, "Shows comments.")
		XCTAssertEqual(elements[2].traits, [.staticText, .button])
		XCTAssertEqual(elements[2].label, "Post by Leanne Graham: ea molestias quasi exercitationem repellat qui ipsa sit aut. Has 5 comments")
		XCTAssertEqual(elements[2].hint, "Shows comments.")
		XCTAssertEqual(elements[3].traits, [.staticText, .button])
		XCTAssertEqual(elements[3].label, "Post by Leanne Graham: eum et est occaecati. Has 5 comments")
		XCTAssertEqual(elements[3].hint, "Shows comments.")
		XCTAssertEqual(elements[4].traits, [.staticText, .button])
		XCTAssertEqual(elements[4].label, "Post by Leanne Graham: nesciunt quas odio. Has 5 comments")
		XCTAssertEqual(elements[4].hint, "Shows comments.")
		// Assert on all remaining elements if desired
	}
}
