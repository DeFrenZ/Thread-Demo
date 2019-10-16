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
	static var baseSamples: [Comment.Connected]! {
		[Comment].samples
			.map({ Comment.Connected(comment: $0) })
	}

	static var samples: [Comment.Connected]! {
		DataStore.connectComments(.baseSamples, toPosts: .baseSamples).comments
	}
}

extension Comment.Connected {
	static var sample: Comment.Connected! { [Comment.Connected].samples.first }
}
