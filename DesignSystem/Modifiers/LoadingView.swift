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
			.accessibility(hidden: showLoader)
			.overlay(loader)
    }

	private var loader: some View {
		ZStack {
			// This should animate by moving the blur radius instead, but it's not publicly available so unless fiddling with animation states — as animating an effect change does animate the blur radius — or using `CIFilter`s, it's not possible.
			BlurEffect(style: .regular)
				.edgesIgnoringSafeArea(.all)
			ActivityIndicator(style: .large)
		}
			// It should be possible to do this effect by using `AnyTransition.opacity` instead, but I didn't manage to make it work with adding/removing views from a `ZStack`
			.opacity(showLoader ? 1 : 0)
			.animation(.default)
	}
}

struct LoadingView_Previews: PreviewProvider {
	private struct Preview: View {
		@State private var showLoading: Bool = true
		var body: some View {
			LoadingView(showLoader: showLoading) {
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
				.overlay(
					Button(action: { self.showLoading.toggle() }) {
						Text("Toggle loading")
							.padding()
							.background(Color.blue)
							.cornerRadius(15)
							.foregroundColor(.white)
					}
						.expand()
						.offset(x: 0, y: 100)
				)
		}
	}

    static var previews: some View {
		Preview()
			.previewLayout(.device)
    }
}
