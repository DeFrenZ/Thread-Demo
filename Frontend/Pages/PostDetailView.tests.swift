import Core
import XCTest
@testable import Frontend

final class PostDetailViewTests: XCTestCase {
}

extension PostDetailViewTests {
	func test_accessibility_default() {
		let view = PostDetailView(post: .sample)
			.frame(width: 300, height: 1_000)

		let elements = view.accessibilityNode
			.flattenedElements

		guard elements.count == 7
		else { return XCTFail("Unexpected elements count: \(elements)") }
		XCTAssertEqual(elements[0].traits, .staticText)
		XCTAssertEqual(elements[0].label, "Post by Leanne Graham: sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
		XCTAssertEqual(elements[1].traits, [.staticText, .header])
		XCTAssertEqual(elements[1].label, "5 comments")
		XCTAssertEqual(elements[2].traits, .staticText)
		XCTAssertEqual(elements[2].label, "Comment by id labore ex et quam laborum: laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
		XCTAssertEqual(elements[3].traits, .staticText)
		XCTAssertEqual(elements[3].label, "Comment by quo vero reiciendis velit similique earum: est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et")
		XCTAssertEqual(elements[4].traits, .staticText)
		XCTAssertEqual(elements[4].label, "Comment by odio adipisci rerum aut animi: quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione")
		XCTAssertEqual(elements[5].traits, .staticText)
		XCTAssertEqual(elements[5].label, "Comment by alias odio sit: non et atque\noccaecati deserunt quas accusantium unde odit nobis qui voluptatem\nquia voluptas consequuntur itaque dolor\net qui rerum deleniti ut occaecati")
		XCTAssertEqual(elements[6].traits, .staticText)
		XCTAssertEqual(elements[6].label, "Comment by vero eaque aliquid doloribus et culpa: harum non quasi et ratione\ntempore iure ex voluptates in ratione\nharum architecto fugit inventore cupiditate\nvoluptates magni quo et")
	}
}
