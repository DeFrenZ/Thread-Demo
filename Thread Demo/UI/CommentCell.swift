import SwiftUI

struct CommentCell: View {
	var comment: Comment

    var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(verbatim: author)
				.font(.subheadline)
				.fontWeight(.bold)
			Text(verbatim: commentBody)
				.fixedSize(horizontal: false, vertical: true)
				.lineLimit(nil)
		}
    }
}

// MARK: Presentation
extension CommentCell {
	var author: String { comment.authorName }
	var commentBody: String { comment.body }
}

// MARK: - Preview
struct CommentCell_Previews: PreviewProvider {
    static var previews: some View {
		CommentCell(comment: .sample)
			.previewLayout(.sizeThatFits)
    }
}
