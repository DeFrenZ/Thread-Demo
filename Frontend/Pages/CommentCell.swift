import Core
import DesignSystem
import SwiftUI

public struct CommentCell: View {
	private var comment: Comment

	public init(comment: Comment) {
		self.comment = comment
	}

    public var body: some View {
		BaseCell(
			author: author,
			username: username,
			cellBody: commentBody
		)
			.accessibilityElement()
			.accessibility(addTraits: .isStaticText)
			.accessibility(label: Text(accessibilityLabel))
    }
}

// MARK: Presentation
extension CommentCell {
	var author: String { comment.authorName }
	var username: String { comment.authorEmail }
	var commentBody: String { comment.body }
	var accessibilityLabel: String { "Comment by \(author): \(commentBody)" }
}

// MARK: - Preview
struct CommentCell_Previews: PreviewProvider {
    static var previews: some View {
		CommentCell(comment: .sample)
			.previewLayout(.sizeThatFits)
			.background(Color(.systemBackground))
			.multiplePreviewEnvironments()
    }
}
