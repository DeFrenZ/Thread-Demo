public func updated <T> (_ value: T, with update: (inout T) -> Void) -> T {
	var editable = value
	update(&editable)
	return editable
}

public func setIfUnequal <T: Equatable> (_ value: inout T, to newValue: T) {
	guard newValue != value else { return }
	value = newValue
}
