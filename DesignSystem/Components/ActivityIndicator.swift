import SwiftUI
import UIKit

public struct ActivityIndicator: UIViewRepresentable {
	private var style: UIActivityIndicatorView.Style
	private var isAnimating: Bool

	public init(
		style: UIActivityIndicatorView.Style = .medium,
		isAnimating: Bool = true
	) {
		self.style = style
		self.isAnimating = isAnimating
	}

	public func makeUIView(context: Context) -> UIActivityIndicatorView {
		UIActivityIndicatorView(style: style)
	}

	public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
		if isAnimating {
			uiView.startAnimating()
		} else {
			uiView.stopAnimating()
		}
	}
}

// MARK: - Preview
struct ActivityIndicator_Preview: PreviewProvider {
	static var previews: some View {
		ActivityIndicator(style: .large, isAnimating: true)
			.previewLayout(.sizeThatFits)
	}
}
