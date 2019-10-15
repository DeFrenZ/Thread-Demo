import SwiftUI

struct PostCell: View {
	var post: Post
	var user: User?
	var comments: [Comment]?

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			username.map(Text.init(verbatim:))
				.font(.headline)
			Text(title)
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

extension PostCell {
	init(connected: Post.Connected) {
		self.init(
			post: connected.post,
			user: connected.user?.user,
			comments: connected.comments?.map({ $0.comment })
		)
	}
}

// MARK: Presentation
extension PostCell {
	var username: String? { user?.username }
	var title: String { post.title }
	// TODO: Support pluralization
	var commentsCount: Int? { comments?.count }
}

// MARK: - Preview
struct PostCell_Preview: PreviewProvider {
	static var previews: some View {
		PostCell(
			post: .sample,
			user: .sample,
			comments: .samples
		)
			.previewLayout(.sizeThatFits)
	}
}
