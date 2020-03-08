import SwiftUI

/// A view that can be used to cover some content with a loader when the content isn't present or complete yet
public struct LoadingView<Content: View>: View {
	private var showLoader: Bool
	private var content: Content

	public init(
		showLoader: Bool,
		@ViewBuilder content contentBuilder: () -> Content
	) {
		self.showLoader = showLoader
		self.content = contentBuilder()
	}

    public var body: some View {
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
		LoadingView(showLoader: true) {
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
			.previewLayout(.device)
    }
}
