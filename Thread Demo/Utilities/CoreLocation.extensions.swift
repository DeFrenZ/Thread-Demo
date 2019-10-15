import CoreLocation

extension CLLocationCoordinate2D: Hashable {
	public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
		return lhs.latitude == rhs.latitude
			&& lhs.longitude == rhs.longitude
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}
}
