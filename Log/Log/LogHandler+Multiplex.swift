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

/// A pseudo-`LogHandler` that can be used to send messages to multiple other `LogHandler`s.
///
/// The first `LogHandler` passed to the initialisation function of `MultiplexLogHandler` control the `logLevel` as
/// well as the `metadata` for this `LogHandler`. Any subsequent `LogHandler`s used to initialise a
/// `MultiplexLogHandler` are merely to emit the log message to another place.
public struct MultiplexLogHandler: LogHandler {
    private var handlers: [LogHandler]

    /// Create a `MultiplexLogHandler`.
    ///
    /// - parameters:
    ///    - handlers: An array of `LogHandler`s, each of which will receive the log messages sent to this `Logger`.
    ///                The array must not be empty.
    public init(_ handlers: [LogHandler]) {
        assert(!handlers.isEmpty)
        self.handlers = handlers
    }

    public var logLevel: Logger.Level {
        get {
            return self.handlers[0].logLevel
        }
        set {
            self.mutatingForEachHandler {
                $0.logLevel = newValue
            }
        }
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String, function: String, line: UInt) {
        self.handlers.forEach { handler in
            handler.log(level: level, message: message, metadata: metadata, file: file, function: function, line: line)
        }
    }

    public var metadata: Logger.Metadata {
        get {
            return self.handlers[0].metadata
        }
        set {
            self.mutatingForEachHandler { $0.metadata = newValue }
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.handlers[0].metadata[metadataKey]
        }
        set {
            self.mutatingForEachHandler { $0[metadataKey: metadataKey] = newValue }
        }
    }

    private mutating func mutatingForEachHandler(_ mutator: (inout LogHandler) -> Void) {
        for index in self.handlers.indices {
            mutator(&self.handlers[index])
        }
    }
}
