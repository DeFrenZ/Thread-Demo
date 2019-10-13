import SwiftUI

struct PostCell: View {
	var post: Post.Connected

	var body: some View {
		VStack(alignment: .leading) {
			username.map(Text.init(verbatim:))
			Text(title)
				.lineLimit(3)
				// Make the `Text` reach its ideal height
				.fixedSize(horizontal: false, vertical: true)
			footer.map(Text.init)
		}
	}
}

// MARK: Presentation
extension PostCell {
	var username: String? { post.user?.username }
	var title: String { post.title }
	var footer: String? { post.comments.map({ "\($0.count) comments" }) }
}

// MARK: - Preview
struct PostCell_Preview: PreviewProvider {
	static var previews: some View {
		PostCell(post: .sample)
			.previewLayout(.sizeThatFits)
	}
}
