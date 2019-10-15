import Foundation

extension Array where Element == Comment {
	static var samples: [Comment]! {
		[API.Comment].samples
			.map(Comment.init(apiModel:))
	}
}

extension Comment {
	static var sample: Comment! { [Comment].samples.first }
}

extension Array where Element == Comment.Connected {
	static var samples: [Comment.Connected]! {
		[Comment].samples
			.map(Comment.Connected.init(comment:))
	}
}

extension Comment.Connected {
	static var sample: Comment.Connected! { [Comment.Connected].samples.first }
}
