import SwiftUI

/// A view that optionally shows a top sliding banner that can be actioned
public struct BannerView<Content: View>: View {
	private var bannerMessage: String?
	private var bannerAction: (() -> Void)?
	private var content: Content

	public init(
		message: String?,
		action: (() -> Void)? = nil,
		@ViewBuilder content contentBuilder: () -> Content
	) {
		self.bannerMessage = message
		self.bannerAction = action
		self.content = contentBuilder()
	}

    public var body: some View {
        VStack(spacing: 0) {
			banner
			content
		}
			.animation(.spring())
    }

	private var banner: some View {
		bannerMessage.map({ message in
			Banner(action: self.bannerAction) {
				Text(message)
			}
				// Ideally this would work for bottom banners as well, but the bottom safe area seems to work differently than the top one, surprisingly... (iOS 13.3)
				.transition(.move(edge: .top))
		})
	}
}

struct BannerView_Previews: PreviewProvider {
	private struct Preview: View {
		@State private var showBanner: Bool = true
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
