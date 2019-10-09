import SwiftUI

struct PostsListView: View {
	@Binding var posts: [Post]

    var body: some View {
		List(posts) { post in
			Text(post.title)
				.lineLimit(nil)
				.fixedSize(horizontal: false, vertical: true)
		}.navigationBarTitle("Posts")
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PostsListView(posts: .constant(.samples))
		}
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
