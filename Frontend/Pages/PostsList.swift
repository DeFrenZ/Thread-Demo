import Combine
import Core
import DesignSystem
import SwiftUI

/// A view that displays a list of posts.
public struct PostsList: View {
	@EnvironmentObject private var dataStore: DataUIStore

    public var body: some View {
		BannerView(
			message: bannerMessage,
			action: { self.performAction(.retry) }
		) {
			LoadingView(showLoader: showLoader) {
				List(posts ?? []) { post in
					NavigationLink(destination: PostDetailView(post: post)) {
						PostCell(post: post)
					}
				}
			}
		}
			.navigationBarTitle("Posts")
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
	private var isAnyStoreIdleWithoutData: Bool {
		if case .idle = dataStore.posts.state, dataStore.posts.lastValidData == nil { return true }
		if case .idle = dataStore.users.state, dataStore.users.lastValidData == nil { return true }
		if case .idle = dataStore.comments.state, dataStore.comments.lastValidData == nil { return true }
		return false
	}
	private var firstStoreError: FetchError? {
		if case .failed(let error) = dataStore.posts.state { return error }
		if case .failed(let error) = dataStore.users.state { return error }
		if case .failed(let error) = dataStore.comments.state { return error }
		return nil
	}
	private var errorMessage: String? {
		guard let error = self.firstStoreError else { return nil }

		// TODO: Give more detailed error messages
		switch error {
		default: return "Could not retrieve data"
		}
	}

	var posts: [Post.Connected]? { postsData.lastValidData?.data }
	var showLoader: Bool { isAnyStoreRetrieving || isAnyStoreIdleWithoutData }
	var bannerMessage: String? {
		errorMessage.map({ "\($0)\ntap to retry" })
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
		let store = DataUIStore.sampleLoaded
		store.fetchAll(.storageOnly)
		return NavigationView {
			PostsList()
		}
			.environmentObject(store)
			.multiplePreviewEnvironments()
	}
}
