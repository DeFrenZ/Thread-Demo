import SwiftUI
import Combine

/// A view that displays a list of posts.
struct PostsListView: View {
	@EnvironmentObject var postsStore: PostsStore

    var body: some View {
		root
			.navigationBarTitle("Posts")
			.onAppear(perform: { self.performAction(.fetchPosts()) })
    }

	@ViewBuilder
	private var root: some View {
		if let posts = self.posts {
			return postsList(with: posts)
		} else {
			return ActivityIndicator(style: .large)
		}
	}

	private func postsList(with posts: [Post.Connected]) -> some View {
		List(posts) { post in
			Text(post.title)
				.lineLimit(3)
				// Make the `Text` reach its ideal height
				.fixedSize(horizontal: false, vertical: true)
		}
	}
}

// MARK: Presentation
extension PostsListView {
	var posts: [Post.Connected]? { postsStore.posts.lastValidData }
}

// MARK: Effects
extension PostsListView {
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
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PostsListView()
		}.environmentObject(PostsStore.sample)
	}
}

private extension PostsStore {
	static var sample: PostsStore {
		.init(getPosts: {
			Just<[Post]>(.samples)
				.setFailureType(to: FetchError.self)
				.eraseToAnyPublisher()
		})
	}
}

private extension Array where Element == Post {
	static var samples: [Post]! {
		guard
			let url = Bundle.main.url(forResource: "posts.response", withExtension: "json"),
			let exampleResponse = try? Data(contentsOf: url)
		else { return nil }

		let decoder = JSONDecoder()

		return try? decoder
			.decode([API.Post].self, from: exampleResponse)
			.map(Post.init(apiModel:))
	}
}
