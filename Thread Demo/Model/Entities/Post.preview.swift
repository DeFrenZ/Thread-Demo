import Foundation

extension Array where Element == Post {
	static var samples: [Post]! {
		[API.Post].samples
			.map(Post.init(apiModel:))
	}
}

extension Post {
	static var sample: Post! { [Post].samples.first }
}

extension Array where Element == Post.Connected {
	static var baseSamples: [Post.Connected]! {
		[Post].samples
			.map({ Post.Connected(post: $0) })
	}

	static var samples: [Post.Connected]! {
		let (withUsers, _) = DataStore.connectPosts(.baseSamples, toUsers: .baseSamples)
		let (_, connected) = DataStore.connectComments(.baseSamples, toPosts: withUsers)
		return connected
	}
}

extension Post.Connected {
	static var sample: Post.Connected! { [Post.Connected].samples.first }
}
