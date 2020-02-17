import Foundation

extension Array where Element == User {
	static var samples: Self! {
		try? [API.User].samples
			.map(Element.init(apiModel:))
	}
}

extension User {
	static var sample: Self! { [Self].samples.first }
}

extension Array where Element == User.Connected {
	static var baseSamples: Self! {
		[User].samples
			.map({ Element(user: $0) })
	}

	static var samples: Self! {
		DataStore.connectPosts(.baseSamples, toUsers: .baseSamples).users
	}
}

extension User.Connected {
	static var sample: Self! { [Self].samples.first }
}
