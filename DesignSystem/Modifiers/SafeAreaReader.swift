import SwiftUI

struct SafeAreaReader<Content: View>: View {
	private var content: Content
	init(@ViewBuilder content contentBuilder: () -> Content) {
		self.content = contentBuilder()
	}

	var body: some View {
		content
			.background(
				GeometryReader { proxy in
					Rectangle()
						.fill(Color.clear)
						.preference(key: SafeAreaKey.self, value: proxy.safeAreaInsets)
				}
					.edgesIgnoringSafeArea(.all)
			)
	}
}

struct SafeAreaKey: PreferenceKey {
	static var defaultValue: EdgeInsets { .init() }

	static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
		let next = nextValue()
		value.top = max(value.top, next.top)
		value.leading = max(value.leading, next.leading)
		value.bottom = max(value.bottom, next.bottom)
		value.trailing = max(value.trailing, next.trailing)
	}
}
