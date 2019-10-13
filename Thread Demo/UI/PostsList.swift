import SwiftUI
import Combine

/// A view that displays a list of posts.
struct PostsList: View {
	@EnvironmentObject var postsStore: PostsStore

    var body: some View {
		root
			.navigationBarTitle("Posts")
			.onAppear(perform: { self.performAction(.fetchPosts()) })
    }

	@ViewBuilder
	private var root: some View {
		if let posts = self.posts {
			return List(posts) { post in
				PostCell(post: post)
			}
		} else {
			return ActivityIndicator(style: .large)
		}
	}
}

// MARK: Presentation
extension PostsList {
	var posts: [Post.Connected]? { postsStore.posts.lastValidData }
}

// MARK: Effects
extension PostsList {
	enum Action {
		case fetchPosts(forceFetch: Bool = false)
	}

	func performAction(_ action: Action) {
		switch action {
		case .fetchPosts(let forceFetch):
			guard forceFetch || shouldFetch else { return }
			postsStore.fetch()
		}
	}

	private var shouldFetch: Bool {
		switch postsStore.posts.state {
		case .idle, .failed: return postsStore.posts.lastValidData == nil
		case .retrieving: return false
		}
	}
}

// MARK: - Preview
struct PostsList_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PostsList()
		}.environmentObject(PostsStore.sample)
	}
}
