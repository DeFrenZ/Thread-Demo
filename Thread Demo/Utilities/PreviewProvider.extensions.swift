import SwiftUI

extension View {
	func multiplePreviewEnvironments(
		sizeCategories: [ContentSizeCategory] = MultiplePreviewEnvironments.defaultSizeCategories,
		colorSchemes: [ColorScheme] = MultiplePreviewEnvironments.defaultColorSchemes
		// TODO: `multipleSizeClasses`
	) -> some View {
		modifier(MultiplePreviewEnvironments(sizeCategories: sizeCategories, colorSchemes: colorSchemes))
	}
}

struct MultiplePreviewEnvironments: ViewModifier {
	var sizeCategories: [ContentSizeCategory] = Self.defaultSizeCategories
	var colorSchemes: [ColorScheme] = Self.defaultColorSchemes

	func body(content: Content) -> some View {
		let correctedSizeCategories = sizeCategories.isEmpty ? [.medium] : sizeCategories
		let correctedColorSchemes = colorSchemes.isEmpty ? [.light] : colorSchemes
		let modifiers = product(correctedSizeCategories, correctedColorSchemes)
			.map(Pair.init)
		return ForEach(modifiers, id: \.self) { pair in
			content
				.environment(\.sizeCategory, pair.item1)
				.environment(\.colorScheme, pair.item2)
				.previewDisplayName(self.displayName(for: pair))
		}
	}

	private func displayName(for pair: Pair<ContentSizeCategory, ColorScheme>) -> String? {
		let computedValue = [
			sizeCategories.isEmpty ? nil : String(describing: pair.item1),
			colorSchemes.isEmpty ? nil : String(describing: pair.item2),
		]
			.compactMap({ $0 })
			.joined(separator: " — ")
		return computedValue.isEmpty ? nil : computedValue
	}

	fileprivate static var defaultSizeCategories: [ContentSizeCategory] = [
		.extraSmall,
		.medium,
		.extraExtraLarge,
	]
	fileprivate static var defaultColorSchemes: [ColorScheme] = [.light, .dark]
}
