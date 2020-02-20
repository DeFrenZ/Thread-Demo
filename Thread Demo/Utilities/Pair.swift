public struct Pair<T, U> {
	public var item1: T
	public var item2: U

	public init(item1: T, item2: U) {
		self.item1 = item1
		self.item2 = item2
	}
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
