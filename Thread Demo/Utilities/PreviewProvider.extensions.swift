import SwiftUI

extension View {
	func multipleSizeCategories(
		_ sizeCategories: [ContentSizeCategory] = [
			.extraSmall,
			.medium,
			.extraExtraLarge,
		]
	) -> some View {
		modifier(MultipleSizeCategories(sizeCategories: sizeCategories))
	}

	func multipleColorSchemes() -> some View {
		modifier(MultipleColorSchemes(colorSchemes: [.light, .dark]))
	}

	// TODO: `multipleSizeClasses`
}

struct MultipleSizeCategories: ViewModifier {
	var sizeCategories: [ContentSizeCategory]

	func body(content: Content) -> some View {
		ForEach(sizeCategories, id: \.self) {
			content
				.environment(\.sizeCategory, $0)
		}
	}
}

struct MultipleColorSchemes: ViewModifier {
	var colorSchemes: [ColorScheme]

	func body(content: Content) -> some View {
		ForEach(colorSchemes, id: \.self) {
			content
				.environment(\.colorScheme, $0)
		}
	}
}
