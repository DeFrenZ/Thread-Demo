import SwiftUI
import Combine

/// A view that displays a list of posts.
struct PostsList: View {
	@EnvironmentObject var postsStore: PostsStore

    var body: some View {
		List(posts ?? []) { post in
			PostCell(connected: post)
		}
			.overlay(isLoading ? ActivityIndicator(style: .large) : nil)
			.navigationBarTitle("Posts")
    }
}

// MARK: Presentation
extension PostsList {
	var posts: [Post.Connected]? { postsStore.posts.lastValidData }
	var isLoading: Bool {
		guard case .retrieving = postsStore.posts.state else { return false }
		return true
	}
	var errorMessage: String? {
		guard case .failed(let error) = postsStore.posts.state else { return nil }

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
			// Keeping the `DataStore` as well to retain the connections
			.environmentObject(store)
			.environmentObject(store.postsStore)
	}
}
