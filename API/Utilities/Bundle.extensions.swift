import Foundation

extension Bundle {
	/// Returns the bundle object that contains the current target.
	static var currentTarget: Bundle { .init(for: Target.self) }

	private final class Target {}
}
