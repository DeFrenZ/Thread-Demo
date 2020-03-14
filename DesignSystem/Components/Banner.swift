import SwiftUI

public struct Banner <Label: View>: View {
	@State private var safeAreaInsets: EdgeInsets = .init()
	private var action: (() -> Void)?
	private var label: Label

	public init(
		action: (() -> Void)? = nil,
		@ViewBuilder label labelBuilder: @escaping () -> Label
	) {
		self.action = action
		self.label = labelBuilder()
	}

	public var body: some View {
		SafeAreaReader {
			Button(action: { self.action?() }) {
				self.label
					.padding()
					.frame(maxWidth: .infinity, minHeight: 44)
					.padding(safeAreaInsets)
					.background(Color.orange)
			}
				.edgesIgnoringSafeArea(.all)
				.font(Font.callout.weight(.semibold))
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
		}
			.onPreferenceChange(SafeAreaKey.self) { safeAreaInsets in
				self.safeAreaInsets = safeAreaInsets
			}
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
		Banner {
			Text("Error message")
		}
			.previewLayout(.sizeThatFits)
			.multiplePreviewEnvironments()
    }
}
