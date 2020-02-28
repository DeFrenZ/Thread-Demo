import SwiftUI

extension PreviewLayout: Equatable {
	public static func == (lhs: PreviewLayout, rhs: PreviewLayout) -> Bool {
		switch (lhs, rhs) {
		case (.device, .device),
			 (.sizeThatFits, .sizeThatFits):
			return true
		case (.fixed(let l), .fixed(let r)) where l == r:
			return true
		default:
			return false
		}
	}
}

extension PreviewLayout: Hashable {
	public func hash(into hasher: inout Hasher) {
		switch self {
		case .device:
			hasher.combine(0)
		case .sizeThatFits:
			hasher.combine(1)
		case .fixed(let width, let height):
			hasher.combine(2)
			hasher.combine(width)
			hasher.combine(height)
		@unknown default:
			hasher.combine(3)
		}
	}
}
