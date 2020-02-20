public final class MemoryStorage {
	private var storage: [Key: Any] = [:]

	public init(initialStorage: [Key: Any]) {
		self.storage = initialStorage
	}
}

extension MemoryStorage: Storage {
	public func isPresent(for key: Key) -> Bool {
		storage[key] != nil
	}

	public func read <Value> (_ type: Value.Type, for key: Key) throws -> Value {
		guard let value = storage[key] else { throw Error.objectNotStored(key: key) }
		guard let castValue = value as? Value else { throw Error.dataCorrupted(key: key) }
		return castValue
	}

	public func write <Value> (_ value: Value, for key: Key) throws {
		storage[key] = value
	}

	public func remove(for key: Key) throws {
		storage[key] = nil
	}
}

extension MemoryStorage: ExpressibleByDictionaryLiteral {
	public convenience init(dictionaryLiteral elements: (Key, Any)...) {
		let uniqued = Dictionary(uniqueKeysWithValues: elements)
		self.init(initialStorage: uniqued)
	}
}
