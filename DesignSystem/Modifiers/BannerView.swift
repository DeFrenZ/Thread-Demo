import SwiftUI

/// A view that optionally shows a top sliding banner that can be actioned
public struct BannerView<Content: View>: View {
	private var bannerMessage: String?
	private var bannerAction: () -> Void
	private var content: Content

	public init(
		message: String?,
		action: @escaping () -> Void = {},
		@ViewBuilder content contentBuilder: () -> Content
	) {
		self.bannerMessage = message
		self.bannerAction = action
		self.content = contentBuilder()
	}

    public var body: some View {
        VStack(spacing: 0) {
			bannerMessage.map({ message in
				Banner(action: self.bannerAction) {
					Text(message)
				}
					.transition(.move(edge: .top))
			})?
				.animation(.spring())
			content
		}
    }
}

struct BannerView_Previews: PreviewProvider {
	private struct Preview: View {
		@State var showBanner: Bool = true
		var body: some View {
			BannerView(message: showBanner ? "Something happened" : nil) {
				Button(action: { self.showBanner.toggle() }) {
					Text("Toggle banner")
						.padding()
						.background(Color.orange)
						.cornerRadius(15)
						.foregroundColor(.white)
				}
					.expand()
			}
		}
	}

    static var previews: some View {
		Group {
			Preview()
			NavigationView {
				Preview()
					.navigationBarTitle("Title", displayMode: .large)
			}
			NavigationView {
				Preview()
					.navigationBarTitle("Title", displayMode: .inline)
			}
		}
			.previewLayout(.device)
    }
}
