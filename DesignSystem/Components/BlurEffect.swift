import SwiftUI
import UIKit

public struct BlurEffect: UIViewRepresentable {
	private var style: UIBlurEffect.Style

	public init(style: UIBlurEffect.Style = .regular) {
		self.style = style
	}

	public func makeUIView(context: Context) -> UIVisualEffectView {
		UIVisualEffectView(effect: UIBlurEffect(style: style))
	}

	public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
	}
}

// MARK: - Preview
struct BlurEffect_Preview: PreviewProvider {
	static var previews: some View {
		ZStack {
			Circle()
			BlurEffect()
		}
			.previewLayout(.sizeThatFits)
	}
}
