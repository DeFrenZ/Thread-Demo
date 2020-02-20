import Foundation

public enum _StorageKey: String {
	case posts = "com.logiccraft.storage.posts"
	case users = "com.logiccraft.storage.users"
	case comments = "com.logiccraft.storage.comments"
}

public enum _StorageError: Error {
	case objectNotStored(key: Storage.Key)
	case authenticationFailed(key: Storage.Key)
	case dataCorrupted(key: Storage.Key)
}

/// An object that manages key-based storage
public protocol Storage {
	// `protocol`s don't allow direct nesting, so this is a workaround for namespacing in `protocol`s
	typealias Error = _StorageError
	typealias Key = _StorageKey

	func isPresent(for key: Key) throws -> Bool
	func read <Value: Decodable> (_ type: Value.Type, for key: Key) throws -> Value
	func write <Value: Encodable> (_ value: Value, for key: Key) throws
	func remove(for key: Key) throws
}

extension Storage {
	public func readIfPresent <Value: Decodable> (_ type: Value.Type, for key: Key) throws -> Value? {
		do {
			return try read(Value.self, for: key)
		} catch Error.objectNotStored(key: key) {
			return nil
		}
	}

	public func writeOrRemove <Value: Encodable> (_ value: Value?, for key: Key) throws {
		guard let value = value else {
			try remove(for: key)
			return
		}
		try write(value, for: key)
	}
}
