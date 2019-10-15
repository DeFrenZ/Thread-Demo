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
	static var samples: [User.Connected]! {
		[User].samples
			.map(User.Connected.init(user:))
	}

	static var samplesConnected: [User.Connected]! {
		guard
			let users = samples,
			let posts = [Post.Connected].samples
		else { return nil }

		DataStore.connectPosts(posts, toUsers: users)
		DataStore.connectComments(.samples, toPosts: posts)
		return users
	}
}

extension User.Connected {
	static var sample: User.Connected! { [User.Connected].samples.first }
	static var sampleConnected: User.Connected! { [User.Connected].samplesConnected.first }
}
