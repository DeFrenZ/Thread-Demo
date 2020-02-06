public struct Pair<T, U> {
	public var item1: T
	public var item2: U
}

extension Pair: Equatable where T: Equatable, U: Equatable {}
extension Pair: Hashable where T: Hashable, U: Hashable {}
extension Pair: Identifiable where T: Identifiable, U: Identifiable {
	public var id: ID {
		ID(id1: item1.id, id2: item2.id)
	}

	public struct ID: Hashable {
		var id1: T.ID
		var id2: U.ID
	}
}

public func updated <T> (_ value: T, with update: (inout T) -> Void) -> T {
	var editable = value
	update(&editable)
	return editable
}

public func setIfUnequal <T: Equatable> (_ value: inout T, to newValue: T) {
	guard newValue != value else { return }
	value = newValue
}
