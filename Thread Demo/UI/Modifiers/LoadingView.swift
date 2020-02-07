import SwiftUI

/// A view that can be used to cover some content with a loader when the content isn't present or complete yet
struct LoadingView<Content: View>: View {
	@Binding var showLoader: Bool
	private var content: Content

	init(
		showLoader: Binding<Bool>,
		@ViewBuilder content contentBuilder: () -> Content
	) {
		self._showLoader = showLoader
		self.content = contentBuilder()
	}

    var body: some View {
        content
			.overlay(showLoader ? loader : nil)
    }

	private var loader: some View {
		ZStack {
			BlurEffect(style: .regular)
				.edgesIgnoringSafeArea([.bottom, .leading, .trailing])
			ActivityIndicator(style: .large)
		}
	}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
		LoadingView(showLoader: .constant(true)) {
			Text("""
				Some example text,
				which happens to be quite long,
				for having a bit of blur effect to go through along
				with all that white
				"""
			)
				.fontWeight(.black)
				.expand()
		}
    }
}
