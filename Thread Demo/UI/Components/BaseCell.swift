import SwiftUI

struct BaseCell<Item: View>: View {
	var author: String?
	var username: String?
	var cellBody: String
	var cellBodyLineLimit: Int?
	var item: Item

	init(
		author: String?,
		username: String?,
		cellBody: String,
		cellBodyLineLimit: Int? = nil,
		@ViewBuilder item: () -> Item
	) {
		self.author = author
		self.username = username
		self.cellBody = cellBody
		self.cellBodyLineLimit = cellBodyLineLimit
		self.item = item()
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack(alignment: .lastTextBaseline) {
				// TODO: Reorganize when text doesn't fit, e.g. moving to a `VStack`
				author.map(Text.init(verbatim:))
					.font(.headline)
					.layoutPriority(1)
				username.map(Text.init(verbatim:))
					.font(.subheadline)
					.foregroundColor(.secondary)
				Spacer()
				item
			}
				.lineLimit(1)
			Text(verbatim: cellBody)
				.lineLimit(cellBodyLineLimit)
				// Make the `Text` reach its ideal height
				.fixedSize(horizontal: false, vertical: true)
		}
	}
}

extension BaseCell where Item == EmptyView {
	init(
		author: String?,
		username: String?,
		cellBody: String,
		cellBodyLineLimit: Int? = nil
	) {
		self.init(
			author: author,
			username: username,
			cellBody: cellBody,
			cellBodyLineLimit: cellBodyLineLimit
		) {
			EmptyView()
		}
	}
}

// MARK: - Preview
struct BaseCell_Preview: PreviewProvider {
	static var previews: some View {
		BaseCell(
			author: "Testy McTestFace",
			username: "testy",
			cellBody: """
				This is a test string. You're going to look at how nice this text looks.
				It's nice isn't it?
				"""
		)
			.previewLayout(.sizeThatFits)
			.background(Color(.systemBackground))
			.multiplePreviewEnvironments()
	}
}
