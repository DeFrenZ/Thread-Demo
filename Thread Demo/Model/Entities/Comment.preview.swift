import Foundation

extension Array where Element == Comment {
	static var samples: Self! {
		[API.Comment].samples
			.map(Element.init(apiModel:))
	}
}

extension Comment {
	static var sample: Self! { [Self].samples.first }
}

extension Array where Element == Comment.Connected {
	static var baseSamples: Self! {
		[Comment].samples
			.map({ Element(comment: $0) })
	}

	static var samples: Self! {
		DataStore.connectComments(.baseSamples, toPosts: .baseSamples).comments
	}
}

extension Comment.Connected {
	static var sample: Self! { [Self].samples.first }
}
