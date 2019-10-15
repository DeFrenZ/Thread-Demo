import SwiftUI

struct PostCell: View {
	var post: Post
	var user: User?
	var comments: [Comment]?

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
	var footer: String? { comments.map({ "\($0.count) comments" }) }
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
