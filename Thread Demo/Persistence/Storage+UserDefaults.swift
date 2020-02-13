import Foundation

extension UserDefaults: Storage {
	// ???: Add flexibility on the encoding/decoding format
	private static let storageEncoder = JSONEncoder()
	private static let storageDecoder = JSONDecoder()

	// NOTE: `JSONEncoder` and `JSONDecoder` don't support leaf values, so to use it with anything we need to make sure that the top level object is an `Array` or a `Dictionary`. In this case we opt for `Array`

	func isPresent(for key: Key) -> Bool {
		Self.logger.info("Checking value for \(public: key.rawValue)")
		return object(forKey: key.rawValue) != nil
	}

	func read <Value: Decodable> (_ type: Value.Type, for key: Key) throws -> Value {
		Self.logger.info("Reading value for \(public: key.rawValue)")
		guard let data = self.data(forKey: key.rawValue) else {
			Self.logger.notice("Value for \(public: key.rawValue) not found")
			throw Error.objectNotStored(key: key)
		}

		let wrappedValue = try Self.storageDecoder.decode([Value].self, from: data)
		guard let value = wrappedValue.first else {
			Self.logger.error("Value for \(public: key.rawValue) corrupted")
			throw Error.dataCorrupted(key: key)
		}

		return value
	}

	func write <Value: Encodable> (_ value: Value, for key: Key) throws {
		Self.logger.info("Setting value for \(public: key.rawValue): \(String(describing: value))")
		let data = try Self.storageEncoder.encode([value])
		set(data, forKey: key.rawValue)
	}

	func remove(for key: Key) {
		Self.logger.info("Removing value for \(public: key.rawValue)")
		// ???: Check if object was there?
		removeObject(forKey: key.rawValue)
	}
}

// MARK: - Logger
private extension UserDefaults {
	static let logger: Logger = .init(label: "User Defaults")
}
