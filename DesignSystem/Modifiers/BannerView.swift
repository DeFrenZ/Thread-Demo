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
			})
			content
		}
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
		BannerView(message: "Something happened") {
			Text("Some very long message")
				.expand()
		}
			.previewLayout(.device)
    }
}
