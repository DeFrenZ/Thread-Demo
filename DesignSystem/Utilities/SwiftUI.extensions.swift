import SwiftUI

extension View {
	public func expand() -> some View {
		frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
	}
}
