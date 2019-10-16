import SwiftUI

struct PostCell: View {
	var post: Post.Connected

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			username.map(Text.init(verbatim:))
				.font(.headline)
			Text(verbatim: title)
				.lineLimit(3)
				// Make the `Text` reach its ideal height
				.fixedSize(horizontal: false, vertical: true)
			commentsCount.map({ count in
				HStack(alignment: .firstTextBaseline, spacing: 6) {
					Text("\(count)")
					Image(systemName: "text.bubble")
						.imageScale(.small)
						.offset(.init(width: 0, height: 1))
				}
					.font(.footnote)
					.foregroundColor(.secondary)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
			})
		}
	}
}

// MARK: Presentation
extension PostCell {
	var username: String? { post.user?.username }
	var title: String { post.title }
	var commentsCount: Int? { post.comments?.count }
}

// MARK: - Preview
struct PostCell_Preview: PreviewProvider {
	static var previews: some View {
		PostCell(post: .sample)
			.previewLayout(.sizeThatFits)
	}
}
