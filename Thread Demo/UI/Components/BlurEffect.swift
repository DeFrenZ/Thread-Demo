import SwiftUI
import UIKit

struct BlurEffect: UIViewRepresentable {
	private let style: UIBlurEffect.Style

	init(style: UIBlurEffect.Style = .regular) {
		self.style = style
	}

	func makeUIView(context: Context) -> UIVisualEffectView {
		UIVisualEffectView(effect: UIBlurEffect(style: style))
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
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
