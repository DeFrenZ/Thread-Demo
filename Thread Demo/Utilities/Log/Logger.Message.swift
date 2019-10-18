extension Logger {
	public struct Message {
		var segments: [Segment]

		enum Segment {
			case `static`(StaticString)
			case dynamic(content: String, privacy: Privacy)

			enum Privacy {
				case `public`
				case `private`
				case `default`
			}
		}
	}
}

// MARK: `*StringConvertible`
extension Logger.Message: CustomStringConvertible {
	public var description: String {
		segments.map({ $0.description }).joined()
	}
}

extension Logger.Message.Segment: CustomStringConvertible {
	var description: String {
		switch self {
		case .static(let string): return string.description
		case .dynamic(let content, _): return content
		}
	}
}

extension Logger.Message: CustomDebugStringConvertible {
	public var debugDescription: String {
		segments.map({ $0.debugDescription }).joined()
	}
}

extension Logger.Message.Segment: CustomDebugStringConvertible {
	var debugDescription: String {
		switch self {
		case .static(let string): return string.debugDescription
		case .dynamic(let content, let privacy): return "{\(privacy.debugDescriptionPrefix)\(content)}"
		}
	}
}

private extension Logger.Message.Segment.Privacy {
	var debugDescriptionPrefix: String {
		switch self {
		case .public: return "public: "
		case .private: return "private: "
		case .default: return ""
		}
	}
}

// MARK: `ExpressibleBy*Literal`
extension Logger.Message: ExpressibleByStringLiteral {
	public init(stringLiteral value: StaticString) {
		self.init(segments: [.static(value)])
	}
}

extension Logger.Message: ExpressibleByStringInterpolation {
	public init(stringInterpolation: StringInterpolation) {
		self.init(segments: stringInterpolation.segments)
	}

	public struct StringInterpolation: StringInterpolationProtocol {
		fileprivate var segments: [Segment] = []

		public init(literalCapacity: Int, interpolationCount: Int) {
			self.segments.reserveCapacity(2 * interpolationCount + 1)
		}

		public mutating func appendLiteral(_ literal: StaticString) {
			segments.append(.static(literal))
		}

		public mutating func appendInterpolation <InterpolatedValue: CustomStringConvertible> (_ value: InterpolatedValue) {
			segments.append(.dynamic(content: value.description, privacy: .default))
		}

		public mutating func appendInterpolation <InterpolatedValue: CustomStringConvertible> (public value: InterpolatedValue) {
			segments.append(.dynamic(content: value.description, privacy: .public))
		}

		public mutating func appendInterpolation <InterpolatedValue: CustomStringConvertible> (private value: InterpolatedValue) {
			segments.append(.dynamic(content: value.description, privacy: .private))
		}
	}
}

// MARK: Operators
public extension Logger.Message {
	static func + (lhs: Self, rhs: Self) -> Self {
		// TODO: Unify the ends in a single segment if both are `static`
		.init(segments: lhs.segments + rhs.segments)
	}
}
