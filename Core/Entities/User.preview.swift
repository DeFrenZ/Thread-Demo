import Foundation

#if ENABLE_SAMPLES
public extension Array where Element == User {
	static var samples: Self! {
		[
			.init(
				id: .init(value: 1),
				name: "Leanne Graham",
				username: "Bret",
				emailAddress: "Sincere@april.biz",
				postalAddress: .init(
					street: "Kulas Light",
					suite: "Apt. 556",
					city: "Gwenborough",
					postalCode: "92998-3874",
					coordinates: .init(
						latitude: -37.3159,
						longitude: 81.1496
					)
				),
				phoneNumber: "1-770-736-8031 x56442",
				urlAddress: URL(string: "hildegard.org")!,
				companyDetails: .init(
					name: "Romaguera-Crona",
					catchPhrase: "Multi-layered client-server neural-net",
					technobabble: "harness real-time e-markets"
				)
			),
			.init(
				id: .init(value: 2),
				name: "Ervin Howell",
				username: "Antonette",
				emailAddress: "Shanna@melissa.tv",
				postalAddress: .init(
					street: "Victor Plains",
					suite: "Suite 879",
					city: "Wisokyburgh",
					postalCode: "90566-7771",
					coordinates: .init(
						latitude: -43.9509,
						longitude: -34.4618
					)
				),
				phoneNumber: "010-692-6593 x09125",
				urlAddress: URL(string: "anastasia.net")!,
				companyDetails: .init(
					name: "Deckow-Crist",
					catchPhrase: "Proactive didactic contingency",
					technobabble: "synergize scalable supply-chains"
				)
			),
			.init(
				id: .init(value: 3),
				name: "Clementine Bauch",
				username: "Samantha",
				emailAddress: "Nathan@yesenia.net",
				postalAddress: .init(
					street: "Douglas Extension",
					suite: "Suite 847",
					city: "McKenziehaven",
					postalCode: "59590-4157",
					coordinates: .init(
						latitude: -68.6102,
						longitude: -47.0653
					)
				),
				phoneNumber: "1-463-123-4447",
				urlAddress: URL(string: "ramiro.info")!,
				companyDetails: .init(
					name: "Romaguera-Jacobson",
					catchPhrase: "Face to face bifurcated interface",
					technobabble: "e-enable strategic applications"
				)
			),
			.init(
				id: .init(value: 4),
				name: "Patricia Lebsack",
				username: "Karianne",
				emailAddress: "Julianne.OConner@kory.org",
				postalAddress: .init(
					street: "Hoeger Mall",
					suite: "Apt. 692",
					city: "South Elvis",
					postalCode: "53919-4257",
					coordinates: .init(
						latitude: 29.4572,
						longitude: -164.2990
					)
				),
				phoneNumber: "493-170-9623 x156",
				urlAddress: URL(string: "kale.biz")!,
				companyDetails: .init(
					name: "Robel-Corkery",
					catchPhrase: "Multi-tiered zero tolerance productivity",
					technobabble: "transition cutting-edge web services"
				)
			),
			.init(
				id: .init(value: 5),
				name: "Chelsey Dietrich",
				username: "Kamren",
				emailAddress: "Lucio_Hettinger@annie.ca",
				postalAddress: .init(
					street: "Skiles Walks",
					suite: "Suite 351",
					city: "Roscoeview",
					postalCode: "33263",
					coordinates: .init(
						latitude: -31.8129,
						longitude: 62.5342
					)
				),
				phoneNumber: "(254)954-1289",
				urlAddress: URL(string: "demarco.info")!,
				companyDetails: .init(
					name: "Keebler LLC",
					catchPhrase: "User-centric fault-tolerant solution",
					technobabble: "revolutionize end-to-end systems"
				)
			),
			.init(
				id: .init(value: 6),
				name: "Mrs. Dennis Schulist",
				username: "Leopoldo_Corkery",
				emailAddress: "Karley_Dach@jasper.info",
				postalAddress: .init(
					street: "Norberto Crossing",
					suite: "Apt. 950",
					city: "South Christy",
					postalCode: "23505-1337",
					coordinates: .init(
						latitude: -71.4197,
						longitude: 71.7478
					)
				),
				phoneNumber: "1-477-935-8478 x6430",
				urlAddress: URL(string: "ola.org")!,
				companyDetails: .init(
					name: "Considine-Lockman",
					catchPhrase: "Synchronised bottom-line interface",
					technobabble: "e-enable innovative applications"
				)
			),
			.init(
				id: .init(value: 7),
				name: "Kurtis Weissnat",
				username: "Elwyn.Skiles",
				emailAddress: "Telly.Hoeger@billy.biz",
				postalAddress: .init(
					street: "Rex Trail",
					suite: "Suite 280",
					city: "Howemouth",
					postalCode: "58804-1099",
					coordinates: .init(
						latitude: 24.8918,
						longitude: 21.8984
					)
				),
				phoneNumber: "210.067.6132",
				urlAddress: URL(string: "elvis.io")!,
				companyDetails: .init(
					name: "Johns Group",
					catchPhrase: "Configurable multimedia task-force",
					technobabble: "generate enterprise e-tailers"
				)
			),
			.init(
				id: .init(value: 8),
				name: "Nicholas Runolfsdottir V",
				username: "Maxime_Nienow",
				emailAddress: "Sherwood@rosamond.me",
				postalAddress: .init(
					street: "Ellsworth Summit",
					suite: "Suite 729",
					city: "Aliyaview",
					postalCode: "45169",
					coordinates: .init(
						latitude: -14.3990,
						longitude: -120.7677
					)
				),
				phoneNumber: "586.493.6943 x140",
				urlAddress: URL(string: "jacynthe.com")!,
				companyDetails: .init(
					name: "Abernathy Group",
					catchPhrase: "Implemented secondary concept",
					technobabble: "e-enable extensible e-tailers"
				)
			),
			.init(
				id: .init(value: 9),
				name: "Glenna Reichert",
				username: "Delphine",
				emailAddress: "Chaim_McDermott@dana.io",
				postalAddress: .init(
					street: "Dayna Park",
					suite: "Suite 449",
					city: "Bartholomebury",
					postalCode: "76495-3109",
					coordinates: .init(
						latitude: 24.6463,
						longitude: -168.8889
					)
				),
				phoneNumber: "(775)976-6794 x41206",
				urlAddress: URL(string: "conrad.com")!,
				companyDetails: .init(
					name: "Yost and Sons",
					catchPhrase: "Switchable contextually-based project",
					technobabble: "aggregate real-time technologies"
				)
			),
			.init(
				id: .init(value: 10),
				name: "Clementina DuBuque",
				username: "Moriah.Stanton",
				emailAddress: "Rey.Padberg@karina.biz",
				postalAddress: .init(
					street: "Kattie Turnpike",
					suite: "Suite 198",
					city: "Lebsackbury",
					postalCode: "31428-2261",
					coordinates: .init(
						latitude: -38.2386,
						longitude: 57.2232
					)
				),
				phoneNumber: "024-648-3804",
				urlAddress: URL(string: "ambrose.net")!,
				companyDetails: .init(
					name: "Hoeger LLC",
					catchPhrase: "Centralized empowering task-force",
					technobabble: "target end-to-end models"
				)
			),
		]
	}
}

public extension User {
	static var sample: Self! { [Self].samples.first }
}

public extension Array where Element == User.Connected {
	static var baseSamples: Self! {
		[User].samples
			.map({ Element(user: $0) })
	}

	static var samples: Self! {
		[Post.Connected].baseSamples.connectedTo(users: .baseSamples).users
	}
}

public extension User.Connected {
	static var sample: Self! { [Self].samples.first }
}
#endif
