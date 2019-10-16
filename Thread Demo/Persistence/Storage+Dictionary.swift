final class MemoryStorage {
	private var storage: [Key: Any] = [:]

	init(initialStorage: [Key: Any]) {
		self.storage = initialStorage
	}
}

extension MemoryStorage: Storage {
	func isPresent(for key: Key) -> Bool {
		storage[key] != nil
	}

	func read <Value> (_ type: Value.Type, for key: Key) throws -> Value {
		guard let value = storage[key] else { throw Error.objectNotStored(key: key) }
		guard let castValue = value as? Value else { throw Error.dataCorrupted(key: key) }
		return castValue
	}

	func write <Value> (_ value: Value, for key: Key) throws {
		storage[key] = value
	}

	func remove(for key: Key) throws {
		storage[key] = nil
	}
}

extension MemoryStorage: ExpressibleByDictionaryLiteral {
	convenience init(dictionaryLiteral elements: (Key, Any)...) {
		let uniqued = Dictionary(uniqueKeysWithValues: elements)
		self.init(initialStorage: uniqued)
	}
}
