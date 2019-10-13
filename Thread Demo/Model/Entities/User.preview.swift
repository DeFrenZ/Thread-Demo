import Foundation

extension Array where Element == User {
	static var samples: [User]! {
		try? [API.User].samples
			.map(User.init(apiModel:))
	}
}

extension Array where Element == User.Connected {
	static var samples: [User.Connected]! {
		[User].samples
			.map(User.Connected.init(user:))
	}
}

extension User.Connected {
	static var sample: User.Connected! { [User.Connected].samples.first }
}
