extension Dictionary where Value: Identifiable, Key == Value.ID {
	init <S: Sequence> (groupingByID values: S) where S.Element == Value {
		let elementsByID = Dictionary <Value.ID, [Value]> (grouping: values, by: { $0.id })
		assert(elementsByID.values.allSatisfy({ $0.count == 1 }), "Multiple \(Value.self) with the same ID fetched")
		// !!!: Safe because `Dictionary(grouping:by:)` won't create an entry in the dictionary if there are no elements with that ID
		self = elementsByID.mapValues({ $0.first! })
	}
}
