import Foundation

extension Array where Element == Post {
	static var samples: [Post]! {
		[API.Post].samples
			.map(Post.init(apiModel:))
	}
}

extension Array where Element == Post.Connected {
	static var samples: [Post.Connected]! {
		[Post].samples
			.map(Post.Connected.init(post:))
	}
}

extension Post.Connected {
	static var sample: Post.Connected! { [Post.Connected].samples.first }
}
