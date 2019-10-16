// TODO: Consider using typed errors instead
/// A wrapper that performs read and writes through a specific field of a `Storage`
/// - warning: Before using the wrapped value the `storage` property has to be set
@propertyWrapper
struct Stored <Value: Codable> {
	var key: Storage.Key
	var storage: Storage!

	init(key: Storage.Key, storage: Storage? = nil) {
		self.key = key
		self.storage = storage
	}

	var wrappedValue: Value? {
		get { try? storage.readIfPresent(Value.self, for: key) }
		set { try? storage.writeOrRemove(newValue, for: key) }
	}
}
