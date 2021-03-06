import Core
import DesignSystem
import SwiftUI

public struct PostCell: View {
	private var post: Post.Connected
	private var showNumberOfComments: Bool = true

	public init(
		post: Post.Connected,
		showNumberOfComments: Bool = true
	) {
		self.post = post
		self.showNumberOfComments = showNumberOfComments
	}

	public var body: some View {
		BaseCell(
			author: author,
			username: username,
			cellBody: title,
			cellBodyLineLimit: 3
		) {
			if showNumberOfComments {
				commentsItem
			} else {
				EmptyView()
			}
		}
			.accessibility(label: Text(accessibilityLabel))
	}

	private var commentsItem: some View {
		commentsCount.map({ count in
			HStack(alignment: .firstTextBaseline, spacing: 6) {
				Text("\(count)")
				Image(systemName: "text.bubble")
					.imageScale(.small)
					.offset(.init(width: 0, height: 1))
			}
				.font(.footnote)
				.foregroundColor(.secondary)
		})
	}
}

// MARK: Presentation
extension PostCell {
	var author: String? { post.user?.name }
	var username: String? { (post.user?.username).map({ "@\($0)" }) }
	var title: String { post.title }
	var commentsCount: Int? { post.comments?.count }
	var accessibilityLabel: String {
		let authorLabel = author.map({ "Post by \($0)" }) ?? "Post"
		let commentsLabel = showNumberOfComments
			? commentsCount.map({ ". Has \($0) comments" }) ?? ""
			: ""
		return "\(authorLabel): \(title)\(commentsLabel)"
	}
}

// MARK: - Preview
struct PostCell_Preview: PreviewProvider {
	static var previews: some View {
		PostCell(post: .sample)
			.previewLayout(.sizeThatFits)
			.background(Color(.systemBackground))
			.multiplePreviewEnvironments()
	}
}
