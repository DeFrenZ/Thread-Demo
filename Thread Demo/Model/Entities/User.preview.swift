import Foundation

extension Array where Element == User {
	static var samples: [User]! {
		try? [API.User].samples
			.map(User.init(apiModel:))
	}
}

extension User {
	static var sample: User! { [User].samples.first }
}

extension Array where Element == User.Connected {
	static var baseSamples: [User.Connected]! {
		[User].samples
			.map({ User.Connected(user: $0) })
	}

	static var samples: [User.Connected]! {
		DataStore.connectPosts(.baseSamples, toUsers: .baseSamples).users
	}
}

extension User.Connected {
	static var sample: User.Connected! { [User.Connected].samples.first }
}
