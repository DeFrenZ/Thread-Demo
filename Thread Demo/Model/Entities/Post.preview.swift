import Foundation

extension Array where Element == Post {
	static var samples: Self! {
		[API.Post].samples
			.map(Element.init(apiModel:))
	}
}

extension Post {
	static var sample: Self! { [Self].samples.first }
}

extension Array where Element == Post.Connected {
	static var baseSamples: Self! {
		[Post].samples
			.map({ Element(post: $0) })
	}

	static var samples: Self! {
		let (withUsers, _) = DataStore.connectPosts(.baseSamples, toUsers: .baseSamples)
		let (_, connected) = DataStore.connectComments(.baseSamples, toPosts: withUsers)
		return connected
	}
}

extension Post.Connected {
	static var sample: Self! { [Self].samples.first }
}
