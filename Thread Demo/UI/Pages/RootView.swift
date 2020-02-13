import SwiftUI

/// The view used as root of the app.
struct RootView: View {
	@EnvironmentObject var dataStore: DataUIStore

    var body: some View {
		NavigationView {
			PostsList()
		}
			.onAppear { self.performAction(.fetchData) }
    }
}

// MARK: Effects
extension RootView {
	enum Action {
		case fetchData
	}

	func performAction(_ action: Action) {
		switch action {
		case .fetchData:
			dataStore.fetchAll()
		}
	}
}

// MARK: - Preview
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        return RootView()
			.environmentObject(DataUIStore.sampleLoaded)
    }
}
