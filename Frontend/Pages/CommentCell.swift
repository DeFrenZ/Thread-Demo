import SwiftUI
import Core
import DesignSystem

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
    }
}

// MARK: Presentation
extension CommentCell {
	var author: String { comment.authorName }
	var username: String { comment.authorEmail }
	var commentBody: String { comment.body }
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