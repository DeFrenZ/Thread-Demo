import SwiftUI

extension View {
	public func expand() -> some View {
		frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
