import UIKit
import SwiftUI

@dynamicMemberLookup
public enum AccessibilityNode {
	case element(Element)
	case container(Container)

	public var isElement: Bool {
		guard case .element = self else { return false }
		return true
	}

	public var element: Element? {
		guard case .element(let element) = self else { return nil }
		return element
	}

	public var isContainer: Bool {
		guard case .container = self else { return false }
		return true
	}

	public var container: Container? {
		guard case .container(let container) = self else { return nil }
		return container
	}

	public subscript <V> (dynamicMember elementKeyPath: KeyPath<Element, V>) -> V? {
		element?[keyPath: elementKeyPath]
	}

	public var flattenedElements: [Element] {
		switch self {
		case .element(let element):
			return [element]
		case .container(let container):
			return container.children
				.flatMap({ $0.flattenedElements })
		}
	}

	public struct Element {
		public var traits: UIAccessibilityTraits
		public var identifier: String?
		public var label: String
		public var value: String?
		public var hint: String?
		public var language: String
		public var textualContext: UIAccessibilityTextualContext?
		public var customRotors: [CustomRotor]
		public var userInputLabels: [String]
		public var frame: CGRect

		public init(
			traits: UIAccessibilityTraits = .none,
			identifier: String? = nil,
			label: String,
			value: String? = nil,
			hint: String? = nil,
			language: String,
			textualContext: UIAccessibilityTextualContext? = nil,
			customRotors: [CustomRotor] = [],
			userInputLabels: [String] = [],
			frame: CGRect = .zero
		) {
			self.traits = traits
			self.identifier = identifier
			self.label = label
			self.value = value
			self.hint = hint
			self.language = language
			self.textualContext = textualContext
			self.customRotors = customRotors
			self.userInputLabels = userInputLabels
			self.frame = frame
		}

		public struct CustomRotor {
			public var name: String
			public var systemType: UIAccessibilityCustomRotor.SystemRotorType
		}
	}

	public struct Container {
		public var type: UIAccessibilityContainerType
		public var identifier: String?
		public var children: [AccessibilityNode]

		public init(
			type: UIAccessibilityContainerType = .none,
			identifier: String? = nil,
			children: [AccessibilityNode] = []
		) {
			self.type = type
			self.identifier = identifier
			self.children = children
		}
	}
}

// MARK: - CustomDebugStringConvertible
extension AccessibilityNode: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .element(let element):
			return element.debugDescription
		case .container(let container):
			let childrenDescriptions = container.children
				.map({ $0.debugDescription })
			let beforeLast = childrenDescriptions
				.dropLast()
				.map({ "├─\($0)" })
				.map({ $0.replacingOccurrences(of: "\n", with: "\n│ ")})
			let last = childrenDescriptions
				.last
				.map({ "└─\($0)" })
				.map({ $0.replacingOccurrences(of: "\n", with: "\n  ")})
				.map({ [$0] })
				?? []
			let childrenDescription = (beforeLast + last)
				.joined(separator: "\n")

			return "┐"
				+ (container.identifier.map({ " \($0)" }) ?? "")
				+ (container.type == .none ? "" : " (\(container.type))")
				+ (childrenDescription.isEmpty ? "" : "\n\(childrenDescription)")
		}
	}
}

extension AccessibilityNode.Element: CustomDebugStringConvertible {
	public var debugDescription: String {
		let propertiesDescriptions: [String?] = [
			"traits: \(traits.debugDescription)",
			customRotors.isEmpty ? nil : "rotors: \(customRotors.debugDescription)",
			#"label: "\#(label)""#,
			value.map({ #"value: "\#($0)""# }),
			hint.map({ #"hint: "\#($0)""# }),
			"language: \(language)",
			textualContext.map({ "context: \($0.rawValue)" }),
			userInputLabels.isEmpty ? nil : "inputLabels: \(userInputLabels.debugDescription)",
			"frame: \(frame.debugDescription)",
		]
		let propertiesDescription = propertiesDescriptions
			.compactMap({ $0 })
			.joined(separator: ", ")
		return "╴\(identifier ?? "Element")(\(propertiesDescription))"
	}
}

// MARK: - UIKit
extension NSObject {
	public var accessibilityNode: AccessibilityNode {
		if let element = accessibilityNodeElement {
			return .element(element)
		} else {
			return .container(.init(
				type: accessibilityContainerType,
				identifier: (self as? UIAccessibilityIdentification)?.accessibilityIdentifier,
				children: accessibilityNodeChildren
			))
		}
	}

	var accessibilityNodeElement: AccessibilityNode.Element? {
		guard isAccessibilityElement else { return nil }
		return .init(
			traits: accessibilityTraits,
			identifier: (self as? UIAccessibilityIdentification)?.accessibilityIdentifier,
			label: accessibilityLabel ?? "",
			value: accessibilityValue,
			hint: accessibilityHint,
			language: accessibilityLanguage ?? Locale.current.identifier,
			textualContext: accessibilityTextualContext,
			customRotors: accessibilityCustomRotors?.map({ $0.accessibilityNodeCustomRotor }) ?? [],
			userInputLabels: accessibilityUserInputLabels,
			frame: accessibilityFrame
		)
	}

	var accessibilityNodeChildren: [AccessibilityNode] {
		if
			let base = accessibilityElements?
				.compactMap({ $0 as? NSObject })
				.map({ $0.accessibilityNode }),
			!base.isEmpty
		{
			return base
		}

		switch self {
		case let window as UIWindow:
			return window
				.rootViewController?
				.accessibilityNodeChildren
				?? []
		case let view as UIView:
			return view
				.subviews
				.sorted(by: { $0.frame.minY }, { $0.frame.minX })
				.flatMap({ $0.accessibilityNodeChildren })
		case let viewController as UIViewController:
			return viewController
				.view
				.accessibilityNodeChildren
				+ viewController
					.children
					.flatMap({ $0.accessibilityNodeChildren })
		default:
			return []
		}
	}
}

extension UIAccessibilityCustomRotor {
	var accessibilityNodeCustomRotor: AccessibilityNode.Element.CustomRotor {
		.init(name: name, systemType: systemRotorType)
	}
}

extension UIAccessibilityTraits: CustomDebugStringConvertible {
	public var debugDescription: String {
		let casesWithDescription: [(traits: UIAccessibilityTraits, description: String)] = [
			(.adjustable, "adjustable"),
			(.allowsDirectInteraction, "allowsDirectInteraction"),
			(.button, "button"),
			(.causesPageTurn, "causesPageTurn"),
			(.header, "header"),
			(.image, "image"),
			(.keyboardKey, "keyboardKey"),
			(.link, "link"),
			(.notEnabled, "notEnabled"),
			(.playsSound, "playsSound"),
			(.searchField, "searchField"),
			(.selected, "selected"),
			(.startsMediaSession, "startsMediaSession"),
			(.staticText, "staticText"),
			(.summaryElement, "summaryElement"),
			(.tabBar, "tabBar"),
			(.updatesFrequently, "updatesFrequently"),
		]
		let elementsDescription = casesWithDescription
			.filter({ self.contains($0.traits) })
			.map({ $0.description })
			.joined(separator: ", ")
		return "[\(elementsDescription)]"
	}
}

// MARK: - SwiftUI
extension View {
	public var accessibilityNode: AccessibilityNode {
		let controller = UIHostingController(rootView: self)
		// Force the SwiftUI engine to render lazily loaded elements
		let window = UIWindow()
		window.rootViewController = controller
		window.isHidden = false
		defer { window.isHidden = true }
		_ = UIGraphicsImageRenderer(size: window.bounds.size).image(actions: { context in
			controller.view.layer.render(in: context.cgContext)
		})

		return controller.accessibilityNode
	}
}

// MARK: - Utilities
extension Sequence {
	func sorted <T1: Comparable> (by property1: (Element) throws -> T1) rethrows -> [Element] {
		try sorted(by: {
			let (lhs1, rhs1) = try (property1($0), property1($1))
			if lhs1 != rhs1 {
				return lhs1 < rhs1
			}
			return true
		})
	}

	func sorted <T1: Comparable, T2: Comparable> (by property1: (Element) throws -> T1, _ property2: (Element) throws -> T2) rethrows -> [Element] {
		try sorted(by: {
			let (lhs1, rhs1) = try (property1($0), property1($1))
			if lhs1 != rhs1 {
				return lhs1 < rhs1
			}
			let (lhs2, rhs2) = try (property2($0), property2($1))
			if lhs2 != rhs2 {
				return lhs2 < rhs2
			}
			return true
		})
	}
}
