import SwiftUI
import Combine

/// A view that displays a list of posts.
struct PostsList: View {
	@EnvironmentObject var dataStore: DataStore

    var body: some View {
		VStack(spacing: 0) {
			bannerErrorMessage.map({ message in
				Banner(action: { self.performAction(.retry) }) {
					Text("\(message)\ntap to retry")
				}
					.transition(.move(edge: .top))
			})
			List(posts ?? []) { post in
				NavigationLink(destination: PostDetailView(post: post)) {
					PostCell(post: post)
				}
			}
				.overlay(showLoader ? ActivityIndicator(style: .large) : nil)
				.navigationBarTitle("Posts")
		}
    }
}

// MARK: Presentation
extension PostsList {
	private var postsData: StoreData<[Post.Connected]> { dataStore.posts }
	private var isAnyStoreRetrieving: Bool {
		if case .retrieving = dataStore.posts.state { return true }
		if case .retrieving = dataStore.users.state { return true }
		if case .retrieving = dataStore.comments.state { return true }
		return false
	}
	private var firstStoreError: FetchError? {
		if case .failed(let error) = dataStore.posts.state { return error }
		if case .failed(let error) = dataStore.users.state { return error }
		if case .failed(let error) = dataStore.comments.state { return error }
		return nil
	}

	var posts: [Post.Connected]? { postsData.lastValidData?.data }
	var showLoader: Bool { isAnyStoreRetrieving }
	var bannerErrorMessage: String? {
		guard let error = self.firstStoreError else { return nil }

		// TODO: Give more detailed error messages
		switch error {
		default: return "Could not retrieve data"
		}
	}
}

// MARK: Effects
extension PostsList {
	enum Action {
		case retry
	}

	func performAction(_ action: Action) {
		switch action {
		case .retry:
			dataStore.fetchAll(.remoteOnly(forced: false))
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
