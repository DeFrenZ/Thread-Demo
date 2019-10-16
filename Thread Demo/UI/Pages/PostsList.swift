import SwiftUI
import Combine

/// A view that displays a list of posts.
struct PostsList: View {
	@EnvironmentObject var dataStore: DataStore

    var body: some View {
		List(posts ?? []) { post in
			NavigationLink(destination: PostDetailView(post: post)) {
				PostCell(post: post)
			}
		}
			.overlay(isLoading ? ActivityIndicator(style: .large) : nil)
			.navigationBarTitle("Posts")
    }
}

// MARK: Presentation
extension PostsList {
	private var postsData: StoreData<[Post.Connected]> { dataStore.posts }

	var posts: [Post.Connected]? { postsData.lastValidData }
	var isLoading: Bool {
		guard case .retrieving = postsData.state else { return false }
		return true
	}
	var errorMessage: String? {
		guard case .failed(let error) = postsData.state else { return nil }

		// TODO: Give more detailed error messages
		switch error {
		default: return "Could not retrieve data"
		}
	}
}

// MARK: - Preview
struct PostsList_Previews: PreviewProvider {
	static var previews: some View {
		let store = DataStore.sample
		store.fetchAll()
		return NavigationView {
			PostsList()
		}
			.environmentObject(store)
			.multipleSizeCategories()
			.multipleColorSchemes()
	}
}
