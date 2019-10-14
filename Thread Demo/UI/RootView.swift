import SwiftUI

/// The view used as root of the app.
struct RootView: View {
	@EnvironmentObject var dataStore: DataStore

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
