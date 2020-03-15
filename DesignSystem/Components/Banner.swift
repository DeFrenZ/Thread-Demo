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
			bannerBody
				.edgesIgnoringSafeArea(.all)
		}
			.onPreferenceChange(SafeAreaKey.self) { safeAreaInsets in
				self.safeAreaInsets = safeAreaInsets
			}
    }

	@ViewBuilder
	private var bannerBody: some View {
		// TODO: Convert to `if-let` (or better, `guard`) when function builders support it
		if action != nil {
			Button(action: action!) {
				mainBody
			}
		} else {
			mainBody
		}
	}

	private var mainBody: some View {
		self.label
			.padding()
			.frame(maxWidth: .infinity, minHeight: 44)
			.padding(safeAreaInsets)
			.background(Color.orange)
			.font(Font.callout.weight(.semibold))
			.foregroundColor(.white)
			.multilineTextAlignment(.center)
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
