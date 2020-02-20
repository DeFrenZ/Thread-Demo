public func product <C1: Collection, C2: Collection> (_ collection1: C1, _ collection2: C2) -> [(C1.Element, C2.Element)] {
	collection1.flatMap({ item1 in
		collection2.map({ item2 in
			(item1, item2)
		})
	})
}
