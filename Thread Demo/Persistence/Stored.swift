// TODO: Consider using typed errors instead
/// A wrapper that performs read and writes through a specific field of a `Storage`
/// - warning: Before using the wrapped or projected value the `storage` property has to be set, either manually or when declaring the wrapper
@propertyWrapper
struct Stored <Value: Codable> {
	var key: Storage.Key
	var storage: Storage!

	init(key: Storage.Key, storage: Storage? = nil) {
		self.key = key
		self.storage = storage
	}

	var wrappedValue: Value? {
		get { try? readIfPresent() }
		set { try? writeOrRemove(newValue) }
	}

	var projectedValue: Self { self }
}

extension Stored {
	func isPresent() throws -> Bool {
		try storage.isPresent(for: key)
	}

	func read() throws -> Value {
		try storage.read(Value.self, for: key)
	}

	func write(_ value: Value) throws {
		try storage.write(value, for: key)
	}

	func remove() throws {
		try storage.remove(for: key)
	}

	func readIfPresent() throws -> Value? {
		try storage.readIfPresent(Value.self, for: key)
	}

	func writeOrRemove(_ value: Value?) throws {
		try storage.writeOrRemove(value, for: key)
	}
}