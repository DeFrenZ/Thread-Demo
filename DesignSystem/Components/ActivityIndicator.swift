import SwiftUI
import UIKit

public struct ActivityIndicator: UIViewRepresentable {
	private let style: UIActivityIndicatorView.Style
	@Binding private var isAnimating: Bool

	public init(
		style: UIActivityIndicatorView.Style = .medium,
		isAnimating: Binding<Bool> = .constant(true)
	) {
		self.style = style
		self._isAnimating = isAnimating
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
		ActivityIndicator(style: .large, isAnimating: .constant(true))
			.previewLayout(.sizeThatFits)
	}
}
