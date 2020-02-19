// Part of https://github.com/apple/swift-log/blob/1.1.1/Sources/Logging/Logging.swift

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Logging API open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Logging API project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Logging API project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#else
import Glibc
#endif

extension Logger {
	/// `Metadata` is a typealias for `[String: Logger.MetadataValue]` the type of the metadata storage.
	public typealias Metadata = [String: MetadataValue]

	/// A logging metadata value. `Logger.MetadataValue` is string, array, and dictionary literal convertible.
	///
	/// `MetadataValue` provides convenient conformances to `ExpressibleByStringInterpolation`,
	/// `ExpressibleByStringLiteral`, `ExpressibleByArrayLiteral`, and `ExpressibleByDictionaryLiteral` which means
	/// that when constructing `MetadataValue`s you should default to using Swift's usual literals.
	///
	/// Examples:
	///  - prefer `logger.info("user logged in", metadata: ["user-id": "\(user.id)"])` over
	///    `..., metadata: ["user-id": .string(user.id.description)])`
	///  - prefer `logger.info("user selected colours", metadata: ["colors": ["\(user.topColor)", "\(user.secondColor)"]])`
	///    over `..., metadata: ["colors": .array([.string("\(user.topColor)"), .string("\(user.secondColor)")])`
	///  - prefer `logger.info("nested info", metadata: ["nested": ["fave-numbers": ["\(1)", "\(2)", "\(3)"], "foo": "bar"]])`
	///    over `..., metadata: ["nested": .dictionary(["fave-numbers": ...])])`
	public enum MetadataValue {
		/// A metadata value which is a `String`.
		///
		/// Because `MetadataValue` implements `ExpressibleByStringInterpolation`, and `ExpressibleByStringLiteral`,
		/// you don't need to type `.string(someType.description)` you can use the string interpolation `"\(someType)"`.
		case string(String)

		/// A metadata value which is some `CustomStringConvertible`.
		case stringConvertible(CustomStringConvertible)

		/// A metadata value which is a dictionary from `String` to `Logger.MetadataValue`.
		///
		/// Because `MetadataValue` implements `ExpressibleByDictionaryLiteral`, you don't need to type
		/// `.dictionary(["foo": .string("bar \(buz)")])`, you can just use the more natural `["foo": "bar \(buz)"]`.
		case dictionary(Metadata)

		/// A metadata value which is an array of `Logger.MetadataValue`s.
		///
		/// Because `MetadataValue` implements `ExpressibleByArrayLiteral`, you don't need to type
		/// `.array([.string("foo"), .string("bar \(buz)")])`, you can just use the more natural `["foo", "bar \(buz)"]`.
		case array([Metadata.Value])
	}
}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9687
// Then we could write it as follows and it would work under Swift 5 and not only 4 as it does currently:
// extension Logger.Metadata.Value: Equatable {
extension Logger.MetadataValue: Equatable {
    public static func == (lhs: Logger.Metadata.Value, rhs: Logger.Metadata.Value) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lhs), .string(let rhs)):
            return lhs == rhs
        case (.stringConvertible(let lhs), .stringConvertible(let rhs)):
            return lhs.description == rhs.description
        case (.array(let lhs), .array(let rhs)):
            return lhs == rhs
        case (.dictionary(let lhs), .dictionary(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9686
extension Logger.MetadataValue: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9686
extension Logger.MetadataValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dictionary(let dict):
            return dict.mapValues { $0.description }.description
        case .array(let list):
            return list.map { $0.description }.description
        case .string(let str):
            return str
        case .stringConvertible(let repr):
            return repr.description
        }
    }
}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9687
extension Logger.MetadataValue: ExpressibleByStringInterpolation {}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9686
extension Logger.MetadataValue: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = Logger.Metadata.Value

    public init(dictionaryLiteral elements: (String, Logger.Metadata.Value)...) {
        self = .dictionary(.init(uniqueKeysWithValues: elements))
    }
}

// Extension has to be done on explicit type rather than Logger.Metadata.Value as workaround for
// https://bugs.swift.org/browse/SR-9686
extension Logger.MetadataValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Logger.Metadata.Value

    public init(arrayLiteral elements: Logger.Metadata.Value...) {
        self = .array(elements)
    }
}
