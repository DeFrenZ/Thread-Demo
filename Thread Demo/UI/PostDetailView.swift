import SwiftUI

struct PostDetailView: View {
	var post: Post.Connected
	@State var numberOfShownComments: Int = 20

    var body: some View {
		return List() {
			Section(
				header: Text(verbatim: title)
					.font(.subheadline)
					.fontWeight(.semibold)
					.lineLimit(nil)
			) {
				Text(verbatim: postBody)
					.lineLimit(nil)
					.fixedSize(horizontal: false, vertical: true)
			}

			Section(
				header: Text(commentsHeader)
			) {
				ForEach(shownComments) {
					CommentCell(comment: $0)
				}
			}
		}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Post", displayMode: .inline)
    }
}

// MARK: Presentation
extension PostDetailView {
	var title: String { post.title }
	var postBody: String { post.body }
	private var commentsCount: Int { post.comments?.count ?? 0 }
	var commentsHeader: String { "\(commentsCount) comments" }
	var shownComments: [Comment] { Array(post.comments?.prefix(numberOfShownComments) ?? []) }
	var showMoreComments: Bool { commentsCount > numberOfShownComments }
}

// MARK: - Preview
struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			PostDetailView(post: .sample)
		}
    }
}
