import Foundation

#if ENABLE_SAMPLES
extension Array where Element == Post {
	public static var samples: Self! {
		[
			.init(
				id: .init(value: 1),
				userID: .init(value: 1),
				title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
				body: """
					quia et suscipit
					suscipit recusandae consequuntur expedita et cum
					reprehenderit molestiae ut ut quas totam
					nostrum rerum est autem sunt rem eveniet architecto
					"""
			),
			.init(
				id: .init(value: 2),
				userID: .init(value: 1),
				title: "qui est esse",
				body: """
					est rerum tempore vitae
					sequi sint nihil reprehenderit dolor beatae ea dolores neque
					fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis
					qui aperiam non debitis possimus qui neque nisi nulla
					"""
			),
			.init(
				id: .init(value: 3),
				userID: .init(value: 1),
				title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
				body: """
					et iusto sed quo iure
					voluptatem occaecati omnis eligendi aut ad
					voluptatem doloribus vel accusantium quis pariatur
					molestiae porro eius odio et labore et velit aut
					"""
			),
			.init(
				id: .init(value: 4),
				userID: .init(value: 1),
				title: "eum et est occaecati",
				body: """
					ullam et saepe reiciendis voluptatem adipisci
					sit amet autem assumenda provident rerum culpa
					quis hic commodi nesciunt rem tenetur doloremque ipsam iure
					quis sunt voluptatem rerum illo velit
					"""
			),
			.init(
				id: .init(value: 5),
				userID: .init(value: 1),
				title: "nesciunt quas odio",
				body: """
					repudiandae veniam quaerat sunt sed
					alias aut fugiat sit autem sed est
					voluptatem omnis possimus esse voluptatibus quis
					est aut tenetur dolor neque
					"""
			),
			.init(
				id: .init(value: 6),
				userID: .init(value: 1),
				title: "dolorem eum magni eos aperiam quia",
				body: """
					ut aspernatur corporis harum nihil quis provident sequi
					mollitia nobis aliquid molestiae
					perspiciatis et ea nemo ab reprehenderit accusantium quas
					voluptate dolores velit et doloremque molestiae
					"""
			),
			.init(
				id: .init(value: 7),
				userID: .init(value: 1),
				title: "magnam facilis autem",
				body: """
					dolore placeat quibusdam ea quo vitae
					magni quis enim qui quis quo nemo aut saepe
					quidem repellat excepturi ut quia
					sunt ut sequi eos ea sed quas
					"""
			),
			.init(
				id: .init(value: 8),
				userID: .init(value: 1),
				title: "dolorem dolore est ipsam",
				body: """
					dignissimos aperiam dolorem qui eum
					facilis quibusdam animi sint suscipit qui sint possimus cum
					quaerat magni maiores excepturi
					ipsam ut commodi dolor voluptatum modi aut vitae
					"""
			),
			.init(
				id: .init(value: 9),
				userID: .init(value: 1),
				title: "nesciunt iure omnis dolorem tempora et accusantium",
				body: """
					consectetur animi nesciunt iure dolore
					enim quia ad
					veniam autem ut quam aut nobis
					et est aut quod aut provident voluptas autem voluptas
					"""
			),
			.init(
				id: .init(value: 10),
				userID: .init(value: 1),
				title: "optio molestias id quia eum",
				body: """
					quo et expedita modi cum officia vel magni
					doloribus qui repudiandae
					vero nisi sit
					quos veniam quod sed accusamus veritatis error
					"""
			),
			.init(
				id: .init(value: 11),
				userID: .init(value: 2),
				title: "et ea vero quia laudantium autem",
				body: """
					delectus reiciendis molestiae occaecati non minima eveniet qui voluptatibus
					accusamus in eum beatae sit
					vel qui neque voluptates ut commodi qui incidunt
					ut animi commodi
					"""
			),
			.init(
				id: .init(value: 12),
				userID: .init(value: 2),
				title: "in quibusdam tempore odit est dolorem",
				body: """
					itaque id aut magnam
					praesentium quia et ea odit et ea voluptas et
					sapiente quia nihil amet occaecati quia id voluptatem
					incidunt ea est distinctio odio
					"""
			),
			.init(
				id: .init(value: 13),
				userID: .init(value: 2),
				title: "dolorum ut in voluptas mollitia et saepe quo animi",
				body: """
					aut dicta possimus sint mollitia voluptas commodi quo doloremque
					iste corrupti reiciendis voluptatem eius rerum
					sit cumque quod eligendi laborum minima
					perferendis recusandae assumenda consectetur porro architecto ipsum ipsam
					"""
			),
			.init(
				id: .init(value: 14),
				userID: .init(value: 2),
				title: "voluptatem eligendi optio",
				body: """
					fuga et accusamus dolorum perferendis illo voluptas
					non doloremque neque facere
					ad qui dolorum molestiae beatae
					sed aut voluptas totam sit illum
					"""
			),
			.init(
				id: .init(value: 15),
				userID: .init(value: 2),
				title: "eveniet quod temporibus",
				body: """
					reprehenderit quos placeat
					velit minima officia dolores impedit repudiandae molestiae nam
					voluptas recusandae quis delectus
					officiis harum fugiat vitae
					"""
			),
			.init(
				id: .init(value: 16),
				userID: .init(value: 2),
				title: "sint suscipit perspiciatis velit dolorum rerum ipsa laboriosam odio",
				body: """
					suscipit nam nisi quo aperiam aut
					asperiores eos fugit maiores voluptatibus quia
					voluptatem quis ullam qui in alias quia est
					consequatur magni mollitia accusamus ea nisi voluptate dicta
					"""
			),
			.init(
				id: .init(value: 17),
				userID: .init(value: 2),
				title: "fugit voluptas sed molestias voluptatem provident",
				body: """
					eos voluptas et aut odit natus earum
					aspernatur fuga molestiae ullam
					deserunt ratione qui eos
					qui nihil ratione nemo velit ut aut id quo
					"""
			),
			.init(
				id: .init(value: 18),
				userID: .init(value: 2),
				title: "voluptate et itaque vero tempora molestiae",
				body: """
					eveniet quo quis
					laborum totam consequatur non dolor
					ut et est repudiandae
					est voluptatem vel debitis et magnam
					"""
			),
			.init(
				id: .init(value: 19),
				userID: .init(value: 2),
				title: "adipisci placeat illum aut reiciendis qui",
				body: """
					illum quis cupiditate provident sit magnam
					ea sed aut omnis
					veniam maiores ullam consequatur atque
					adipisci quo iste expedita sit quos voluptas
					"""
			),
			.init(
				id: .init(value: 20),
				userID: .init(value: 2),
				title: "doloribus ad provident suscipit at",
				body: """
					qui consequuntur ducimus possimus quisquam amet similique
					suscipit porro ipsam amet
					eos veritatis officiis exercitationem vel fugit aut necessitatibus totam
					omnis rerum consequatur expedita quidem cumque explicabo
					"""
			),
			.init(
				id: .init(value: 21),
				userID: .init(value: 3),
				title: "asperiores ea ipsam voluptatibus modi minima quia sint",
				body: """
					repellat aliquid praesentium dolorem quo
					sed totam minus non itaque
					nihil labore molestiae sunt dolor eveniet hic recusandae veniam
					tempora et tenetur expedita sunt
					"""
			),
			.init(
				id: .init(value: 22),
				userID: .init(value: 3),
				title: "dolor sint quo a velit explicabo quia nam",
				body: """
					eos qui et ipsum ipsam suscipit aut
					sed omnis non odio
					expedita earum mollitia molestiae aut atque rem suscipit
					nam impedit esse
					"""
			),
			.init(
				id: .init(value: 23),
				userID: .init(value: 3),
				title: "maxime id vitae nihil numquam",
				body: """
					veritatis unde neque eligendi
					quae quod architecto quo neque vitae
					est illo sit tempora doloremque fugit quod
					et et vel beatae sequi ullam sed tenetur perspiciatis
					"""
			),
			.init(
				id: .init(value: 24),
				userID: .init(value: 3),
				title: "autem hic labore sunt dolores incidunt",
				body: """
					enim et ex nulla
					omnis voluptas quia qui
					voluptatem consequatur numquam aliquam sunt
					totam recusandae id dignissimos aut sed asperiores deserunt
					"""
			),
			.init(
				id: .init(value: 25),
				userID: .init(value: 3),
				title: "rem alias distinctio quo quis",
				body: """
					ullam consequatur ut
					omnis quis sit vel consequuntur
					ipsa eligendi ipsum molestiae et omnis error nostrum
					molestiae illo tempore quia et distinctio
					"""
			),
			.init(
				id: .init(value: 26),
				userID: .init(value: 3),
				title: "est et quae odit qui non",
				body: """
					similique esse doloribus nihil accusamus
					omnis dolorem fuga consequuntur reprehenderit fugit recusandae temporibus
					perspiciatis cum ut laudantium
					omnis aut molestiae vel vero
					"""
			),
			.init(
				id: .init(value: 27),
				userID: .init(value: 3),
				title: "quasi id et eos tenetur aut quo autem",
				body: """
					eum sed dolores ipsam sint possimus debitis occaecati
					debitis qui qui et
					ut placeat enim earum aut odit facilis
					consequatur suscipit necessitatibus rerum sed inventore temporibus consequatur
					"""
			),
			.init(
				id: .init(value: 28),
				userID: .init(value: 3),
				title: "delectus ullam et corporis nulla voluptas sequi",
				body: """
					non et quaerat ex quae ad maiores
					maiores recusandae totam aut blanditiis mollitia quas illo
					ut voluptatibus voluptatem
					similique nostrum eum
					"""
			),
			.init(
				id: .init(value: 29),
				userID: .init(value: 3),
				title: "iusto eius quod necessitatibus culpa ea",
				body: """
					odit magnam ut saepe sed non qui
					tempora atque nihil
					accusamus illum doloribus illo dolor
					eligendi repudiandae odit magni similique sed cum maiores
					"""
			),
			.init(
				id: .init(value: 30),
				userID: .init(value: 3),
				title: "a quo magni similique perferendis",
				body: """
					alias dolor cumque
					impedit blanditiis non eveniet odio maxime
					blanditiis amet eius quis tempora quia autem rem
					a provident perspiciatis quia
					"""
			),
			.init(
				id: .init(value: 31),
				userID: .init(value: 4),
				title: "ullam ut quidem id aut vel consequuntur",
				body: """
					debitis eius sed quibusdam non quis consectetur vitae
					impedit ut qui consequatur sed aut in
					quidem sit nostrum et maiores adipisci atque
					quaerat voluptatem adipisci repudiandae
					"""
			),
			.init(
				id: .init(value: 32),
				userID: .init(value: 4),
				title: "doloremque illum aliquid sunt",
				body: """
					deserunt eos nobis asperiores et hic
					est debitis repellat molestiae optio
					nihil ratione ut eos beatae quibusdam distinctio maiores
					earum voluptates et aut adipisci ea maiores voluptas maxime
					"""
			),
			.init(
				id: .init(value: 33),
				userID: .init(value: 4),
				title: "qui explicabo molestiae dolorem",
				body: """
					rerum ut et numquam laborum odit est sit
					id qui sint in
					quasi tenetur tempore aperiam et quaerat qui in
					rerum officiis sequi cumque quod
					"""
			),
			.init(
				id: .init(value: 34),
				userID: .init(value: 4),
				title: "magnam ut rerum iure",
				body: """
					ea velit perferendis earum ut voluptatem voluptate itaque iusto
					totam pariatur in
					nemo voluptatem voluptatem autem magni tempora minima in
					est distinctio qui assumenda accusamus dignissimos officia nesciunt nobis
					"""
			),
			.init(
				id: .init(value: 35),
				userID: .init(value: 4),
				title: "id nihil consequatur molestias animi provident",
				body: """
					nisi error delectus possimus ut eligendi vitae
					placeat eos harum cupiditate facilis reprehenderit voluptatem beatae
					modi ducimus quo illum voluptas eligendi
					et nobis quia fugit
					"""
			),
			.init(
				id: .init(value: 36),
				userID: .init(value: 4),
				title: "fuga nam accusamus voluptas reiciendis itaque",
				body: """
					ad mollitia et omnis minus architecto odit
					voluptas doloremque maxime aut non ipsa qui alias veniam
					blanditiis culpa aut quia nihil cumque facere et occaecati
					qui aspernatur quia eaque ut aperiam inventore
					"""
			),
			.init(
				id: .init(value: 37),
				userID: .init(value: 4),
				title: "provident vel ut sit ratione est",
				body: """
					debitis et eaque non officia sed nesciunt pariatur vel
					voluptatem iste vero et ea
					numquam aut expedita ipsum nulla in
					voluptates omnis consequatur aut enim officiis in quam qui
					"""
			),
			.init(
				id: .init(value: 38),
				userID: .init(value: 4),
				title: "explicabo et eos deleniti nostrum ab id repellendus",
				body: """
					animi esse sit aut sit nesciunt assumenda eum voluptas
					quia voluptatibus provident quia necessitatibus ea
					rerum repudiandae quia voluptatem delectus fugit aut id quia
					ratione optio eos iusto veniam iure
					"""
			),
			.init(
				id: .init(value: 39),
				userID: .init(value: 4),
				title: "eos dolorem iste accusantium est eaque quam",
				body: """
					corporis rerum ducimus vel eum accusantium
					maxime aspernatur a porro possimus iste omnis
					est in deleniti asperiores fuga aut
					voluptas sapiente vel dolore minus voluptatem incidunt ex
					"""
			),
			.init(
				id: .init(value: 40),
				userID: .init(value: 4),
				title: "enim quo cumque",
				body: """
					ut voluptatum aliquid illo tenetur nemo sequi quo facilis
					ipsum rem optio mollitia quas
					voluptatem eum voluptas qui
					unde omnis voluptatem iure quasi maxime voluptas nam
					"""
			),
			.init(
				id: .init(value: 41),
				userID: .init(value: 5),
				title: "non est facere",
				body: """
					molestias id nostrum
					excepturi molestiae dolore omnis repellendus quaerat saepe
					consectetur iste quaerat tenetur asperiores accusamus ex ut
					nam quidem est ducimus sunt debitis saepe
					"""
			),
			.init(
				id: .init(value: 42),
				userID: .init(value: 5),
				title: "commodi ullam sint et excepturi error explicabo praesentium voluptas",
				body: """
					odio fugit voluptatum ducimus earum autem est incidunt voluptatem
					odit reiciendis aliquam sunt sequi nulla dolorem
					non facere repellendus voluptates quia
					ratione harum vitae ut
					"""
			),
			.init(
				id: .init(value: 43),
				userID: .init(value: 5),
				title: "eligendi iste nostrum consequuntur adipisci praesentium sit beatae perferendis",
				body: """
					similique fugit est
					illum et dolorum harum et voluptate eaque quidem
					exercitationem quos nam commodi possimus cum odio nihil nulla
					dolorum exercitationem magnam ex et a et distinctio debitis
					"""
			),
			.init(
				id: .init(value: 44),
				userID: .init(value: 5),
				title: "optio dolor molestias sit",
				body: """
					temporibus est consectetur dolore
					et libero debitis vel velit laboriosam quia
					ipsum quibusdam qui itaque fuga rem aut
					ea et iure quam sed maxime ut distinctio quae
					"""
			),
			.init(
				id: .init(value: 45),
				userID: .init(value: 5),
				title: "ut numquam possimus omnis eius suscipit laudantium iure",
				body: """
					est natus reiciendis nihil possimus aut provident
					ex et dolor
					repellat pariatur est
					nobis rerum repellendus dolorem autem
					"""
			),
			.init(
				id: .init(value: 46),
				userID: .init(value: 5),
				title: "aut quo modi neque nostrum ducimus",
				body: """
					voluptatem quisquam iste
					voluptatibus natus officiis facilis dolorem
					quis quas ipsam
					vel et voluptatum in aliquid
					"""
			),
			.init(
				id: .init(value: 47),
				userID: .init(value: 5),
				title: "quibusdam cumque rem aut deserunt",
				body: """
					voluptatem assumenda ut qui ut cupiditate aut impedit veniam
					occaecati nemo illum voluptatem laudantium
					molestiae beatae rerum ea iure soluta nostrum
					eligendi et voluptate
					"""
			),
			.init(
				id: .init(value: 48),
				userID: .init(value: 5),
				title: "ut voluptatem illum ea doloribus itaque eos",
				body: """
					voluptates quo voluptatem facilis iure occaecati
					vel assumenda rerum officia et
					illum perspiciatis ab deleniti
					laudantium repellat ad ut et autem reprehenderit
					"""
			),
			.init(
				id: .init(value: 49),
				userID: .init(value: 5),
				title: "laborum non sunt aut ut assumenda perspiciatis voluptas",
				body: """
					inventore ab sint
					natus fugit id nulla sequi architecto nihil quaerat
					eos tenetur in in eum veritatis non
					quibusdam officiis aspernatur cumque aut commodi aut
					"""
			),
			.init(
				id: .init(value: 50),
				userID: .init(value: 5),
				title: "repellendus qui recusandae incidunt voluptates tenetur qui omnis exercitationem",
				body: """
					error suscipit maxime adipisci consequuntur recusandae
					voluptas eligendi et est et voluptates
					quia distinctio ab amet quaerat molestiae et vitae
					adipisci impedit sequi nesciunt quis consectetur
					"""
			),
			.init(
				id: .init(value: 51),
				userID: .init(value: 6),
				title: "soluta aliquam aperiam consequatur illo quis voluptas",
				body: """
					sunt dolores aut doloribus
					dolore doloribus voluptates tempora et
					doloremque et quo
					cum asperiores sit consectetur dolorem
					"""
			),
			.init(
				id: .init(value: 52),
				userID: .init(value: 6),
				title: "qui enim et consequuntur quia animi quis voluptate quibusdam",
				body: """
					iusto est quibusdam fuga quas quaerat molestias
					a enim ut sit accusamus enim
					temporibus iusto accusantium provident architecto
					soluta esse reprehenderit qui laborum
					"""
			),
			.init(
				id: .init(value: 53),
				userID: .init(value: 6),
				title: "ut quo aut ducimus alias",
				body: """
					minima harum praesentium eum rerum illo dolore
					quasi exercitationem rerum nam
					porro quis neque quo
					consequatur minus dolor quidem veritatis sunt non explicabo similique
					"""
			),
			.init(
				id: .init(value: 54),
				userID: .init(value: 6),
				title: "sit asperiores ipsam eveniet odio non quia",
				body: """
					totam corporis dignissimos
					vitae dolorem ut occaecati accusamus
					ex velit deserunt
					et exercitationem vero incidunt corrupti mollitia
					"""
			),
			.init(
				id: .init(value: 55),
				userID: .init(value: 6),
				title: "sit vel voluptatem et non libero",
				body: """
					debitis excepturi ea perferendis harum libero optio
					eos accusamus cum fuga ut sapiente repudiandae
					et ut incidunt omnis molestiae
					nihil ut eum odit
					"""
			),
			.init(
				id: .init(value: 56),
				userID: .init(value: 6),
				title: "qui et at rerum necessitatibus",
				body: """
					aut est omnis dolores
					neque rerum quod ea rerum velit pariatur beatae excepturi
					et provident voluptas corrupti
					corporis harum reprehenderit dolores eligendi
					"""
			),
			.init(
				id: .init(value: 57),
				userID: .init(value: 6),
				title: "sed ab est est",
				body: """
					at pariatur consequuntur earum quidem
					quo est laudantium soluta voluptatem
					qui ullam et est
					et cum voluptas voluptatum repellat est
					"""
			),
			.init(
				id: .init(value: 58),
				userID: .init(value: 6),
				title: "voluptatum itaque dolores nisi et quasi",
				body: """
					veniam voluptatum quae adipisci id
					et id quia eos ad et dolorem
					aliquam quo nisi sunt eos impedit error
					ad similique veniam
					"""
			),
			.init(
				id: .init(value: 59),
				userID: .init(value: 6),
				title: "qui commodi dolor at maiores et quis id accusantium",
				body: """
					perspiciatis et quam ea autem temporibus non voluptatibus qui
					beatae a earum officia nesciunt dolores suscipit voluptas et
					animi doloribus cum rerum quas et magni
					et hic ut ut commodi expedita sunt
					"""
			),
			.init(
				id: .init(value: 60),
				userID: .init(value: 6),
				title: "consequatur placeat omnis quisquam quia reprehenderit fugit veritatis facere",
				body: """
					asperiores sunt ab assumenda cumque modi velit
					qui esse omnis
					voluptate et fuga perferendis voluptas
					illo ratione amet aut et omnis
					"""
			),
			.init(
				id: .init(value: 61),
				userID: .init(value: 7),
				title: "voluptatem doloribus consectetur est ut ducimus",
				body: """
					ab nemo optio odio
					delectus tenetur corporis similique nobis repellendus rerum omnis facilis
					vero blanditiis debitis in nesciunt doloribus dicta dolores
					magnam minus velit
					"""
			),
			.init(
				id: .init(value: 62),
				userID: .init(value: 7),
				title: "beatae enim quia vel",
				body: """
					enim aspernatur illo distinctio quae praesentium
					beatae alias amet delectus qui voluptate distinctio
					odit sint accusantium autem omnis
					quo molestiae omnis ea eveniet optio
					"""
			),
			.init(
				id: .init(value: 63),
				userID: .init(value: 7),
				title: "voluptas blanditiis repellendus animi ducimus error sapiente et suscipit",
				body: """
					enim adipisci aspernatur nemo
					numquam omnis facere dolorem dolor ex quis temporibus incidunt
					ab delectus culpa quo reprehenderit blanditiis asperiores
					accusantium ut quam in voluptatibus voluptas ipsam dicta
					"""
			),
			.init(
				id: .init(value: 64),
				userID: .init(value: 7),
				title: "et fugit quas eum in in aperiam quod",
				body: """
					id velit blanditiis
					eum ea voluptatem
					molestiae sint occaecati est eos perspiciatis
					incidunt a error provident eaque aut aut qui
					"""
			),
			.init(
				id: .init(value: 65),
				userID: .init(value: 7),
				title: "consequatur id enim sunt et et",
				body: """
					voluptatibus ex esse
					sint explicabo est aliquid cumque adipisci fuga repellat labore
					molestiae corrupti ex saepe at asperiores et perferendis
					natus id esse incidunt pariatur
					"""
			),
			.init(
				id: .init(value: 66),
				userID: .init(value: 7),
				title: "repudiandae ea animi iusto",
				body: """
					officia veritatis tenetur vero qui itaque
					sint non ratione
					sed et ut asperiores iusto eos molestiae nostrum
					veritatis quibusdam et nemo iusto saepe
					"""
			),
			.init(
				id: .init(value: 67),
				userID: .init(value: 7),
				title: "aliquid eos sed fuga est maxime repellendus",
				body: """
					reprehenderit id nostrum
					voluptas doloremque pariatur sint et accusantium quia quod aspernatur
					et fugiat amet
					non sapiente et consequatur necessitatibus molestiae
					"""
			),
			.init(
				id: .init(value: 68),
				userID: .init(value: 7),
				title: "odio quis facere architecto reiciendis optio",
				body: """
					magnam molestiae perferendis quisquam
					qui cum reiciendis
					quaerat animi amet hic inventore
					ea quia deleniti quidem saepe porro velit
					"""
			),
			.init(
				id: .init(value: 69),
				userID: .init(value: 7),
				title: "fugiat quod pariatur odit minima",
				body: """
					officiis error culpa consequatur modi asperiores et
					dolorum assumenda voluptas et vel qui aut vel rerum
					voluptatum quisquam perspiciatis quia rerum consequatur totam quas
					sequi commodi repudiandae asperiores et saepe a
					"""
			),
			.init(
				id: .init(value: 70),
				userID: .init(value: 7),
				title: "voluptatem laborum magni",
				body: """
					sunt repellendus quae
					est asperiores aut deleniti esse accusamus repellendus quia aut
					quia dolorem unde
					eum tempora esse dolore
					"""
			),
			.init(
				id: .init(value: 71),
				userID: .init(value: 8),
				title: "et iusto veniam et illum aut fuga",
				body: """
					occaecati a doloribus
					iste saepe consectetur placeat eum voluptate dolorem et
					qui quo quia voluptas
					rerum ut id enim velit est perferendis
					"""
			),
			.init(
				id: .init(value: 72),
				userID: .init(value: 8),
				title: "sint hic doloribus consequatur eos non id",
				body: """
					quam occaecati qui deleniti consectetur
					consequatur aut facere quas exercitationem aliquam hic voluptas
					neque id sunt ut aut accusamus
					sunt consectetur expedita inventore velit
					"""
			),
			.init(
				id: .init(value: 73),
				userID: .init(value: 8),
				title: "consequuntur deleniti eos quia temporibus ab aliquid at",
				body: """
					voluptatem cumque tenetur consequatur expedita ipsum nemo quia explicabo
					aut eum minima consequatur
					tempore cumque quae est et
					et in consequuntur voluptatem voluptates aut
					"""
			),
			.init(
				id: .init(value: 74),
				userID: .init(value: 8),
				title: "enim unde ratione doloribus quas enim ut sit sapiente",
				body: """
					odit qui et et necessitatibus sint veniam
					mollitia amet doloremque molestiae commodi similique magnam et quam
					blanditiis est itaque
					quo et tenetur ratione occaecati molestiae tempora
					"""
			),
			.init(
				id: .init(value: 75),
				userID: .init(value: 8),
				title: "dignissimos eum dolor ut enim et delectus in",
				body: """
					commodi non non omnis et voluptas sit
					autem aut nobis magnam et sapiente voluptatem
					et laborum repellat qui delectus facilis temporibus
					rerum amet et nemo voluptate expedita adipisci error dolorem
					"""
			),
			.init(
				id: .init(value: 76),
				userID: .init(value: 8),
				title: "doloremque officiis ad et non perferendis",
				body: """
					ut animi facere
					totam iusto tempore
					molestiae eum aut et dolorem aperiam
					quaerat recusandae totam odio
					"""
			),
			.init(
				id: .init(value: 77),
				userID: .init(value: 8),
				title: "necessitatibus quasi exercitationem odio",
				body: """
					modi ut in nulla repudiandae dolorum nostrum eos
					aut consequatur omnis
					ut incidunt est omnis iste et quam
					voluptates sapiente aliquam asperiores nobis amet corrupti repudiandae provident
					"""
			),
			.init(
				id: .init(value: 78),
				userID: .init(value: 8),
				title: "quam voluptatibus rerum veritatis",
				body: """
					nobis facilis odit tempore cupiditate quia
					assumenda doloribus rerum qui ea
					illum et qui totam
					aut veniam repellendus
					"""
			),
			.init(
				id: .init(value: 79),
				userID: .init(value: 8),
				title: "pariatur consequatur quia magnam autem omnis non amet",
				body: """
					libero accusantium et et facere incidunt sit dolorem
					non excepturi qui quia sed laudantium
					quisquam molestiae ducimus est
					officiis esse molestiae iste et quos
					"""
			),
			.init(
				id: .init(value: 80),
				userID: .init(value: 8),
				title: "labore in ex et explicabo corporis aut quas",
				body: """
					ex quod dolorem ea eum iure qui provident amet
					quia qui facere excepturi et repudiandae
					asperiores molestias provident
					minus incidunt vero fugit rerum sint sunt excepturi provident
					"""
			),
			.init(
				id: .init(value: 81),
				userID: .init(value: 9),
				title: "tempora rem veritatis voluptas quo dolores vero",
				body: """
					facere qui nesciunt est voluptatum voluptatem nisi
					sequi eligendi necessitatibus ea at rerum itaque
					harum non ratione velit laboriosam quis consequuntur
					ex officiis minima doloremque voluptas ut aut
					"""
			),
			.init(
				id: .init(value: 82),
				userID: .init(value: 9),
				title: "laudantium voluptate suscipit sunt enim enim",
				body: """
					ut libero sit aut totam inventore sunt
					porro sint qui sunt molestiae
					consequatur cupiditate qui iste ducimus adipisci
					dolor enim assumenda soluta laboriosam amet iste delectus hic
					"""
			),
			.init(
				id: .init(value: 83),
				userID: .init(value: 9),
				title: "odit et voluptates doloribus alias odio et",
				body: """
					est molestiae facilis quis tempora numquam nihil qui
					voluptate sapiente consequatur est qui
					necessitatibus autem aut ipsa aperiam modi dolore numquam
					reprehenderit eius rem quibusdam
					"""
			),
			.init(
				id: .init(value: 84),
				userID: .init(value: 9),
				title: "optio ipsam molestias necessitatibus occaecati facilis veritatis dolores aut",
				body: """
					sint molestiae magni a et quos
					eaque et quasi
					ut rerum debitis similique veniam
					recusandae dignissimos dolor incidunt consequatur odio
					"""
			),
			.init(
				id: .init(value: 85),
				userID: .init(value: 9),
				title: "dolore veritatis porro provident adipisci blanditiis et sunt",
				body: """
					similique sed nisi voluptas iusto omnis
					mollitia et quo
					assumenda suscipit officia magnam sint sed tempora
					enim provident pariatur praesentium atque animi amet ratione
					"""
			),
			.init(
				id: .init(value: 86),
				userID: .init(value: 9),
				title: "placeat quia et porro iste",
				body: """
					quasi excepturi consequatur iste autem temporibus sed molestiae beatae
					et quaerat et esse ut
					voluptatem occaecati et vel explicabo autem
					asperiores pariatur deserunt optio
					"""
			),
			.init(
				id: .init(value: 87),
				userID: .init(value: 9),
				title: "nostrum quis quasi placeat",
				body: """
					eos et molestiae
					nesciunt ut a
					dolores perspiciatis repellendus repellat aliquid
					magnam sint rem ipsum est
					"""
			),
			.init(
				id: .init(value: 88),
				userID: .init(value: 9),
				title: "sapiente omnis fugit eos",
				body: """
					consequatur omnis est praesentium
					ducimus non iste
					neque hic deserunt
					voluptatibus veniam cum et rerum sed
					"""
			),
			.init(
				id: .init(value: 89),
				userID: .init(value: 9),
				title: "sint soluta et vel magnam aut ut sed qui",
				body: """
					repellat aut aperiam totam temporibus autem et
					architecto magnam ut
					consequatur qui cupiditate rerum quia soluta dignissimos nihil iure
					tempore quas est
					"""
			),
			.init(
				id: .init(value: 90),
				userID: .init(value: 9),
				title: "ad iusto omnis odit dolor voluptatibus",
				body: """
					minus omnis soluta quia
					qui sed adipisci voluptates illum ipsam voluptatem
					eligendi officia ut in
					eos soluta similique molestias praesentium blanditiis
					"""
			),
			.init(
				id: .init(value: 91),
				userID: .init(value: 10),
				title: "aut amet sed",
				body: """
					libero voluptate eveniet aperiam sed
					sunt placeat suscipit molestias
					similique fugit nam natus
					expedita consequatur consequatur dolores quia eos et placeat
					"""
			),
			.init(
				id: .init(value: 92),
				userID: .init(value: 10),
				title: "ratione ex tenetur perferendis",
				body: """
					aut et excepturi dicta laudantium sint rerum nihil
					laudantium et at
					a neque minima officia et similique libero et
					commodi voluptate qui
					"""
			),
			.init(
				id: .init(value: 93),
				userID: .init(value: 10),
				title: "beatae soluta recusandae",
				body: """
					dolorem quibusdam ducimus consequuntur dicta aut quo laboriosam
					voluptatem quis enim recusandae ut sed sunt
					nostrum est odit totam
					sit error sed sunt eveniet provident qui nulla
					"""
			),
			.init(
				id: .init(value: 94),
				userID: .init(value: 10),
				title: "qui qui voluptates illo iste minima",
				body: """
					aspernatur expedita soluta quo ab ut similique
					expedita dolores amet
					sed temporibus distinctio magnam saepe deleniti
					omnis facilis nam ipsum natus sint similique omnis
					"""
			),
			.init(
				id: .init(value: 95),
				userID: .init(value: 10),
				title: "id minus libero illum nam ad officiis",
				body: """
					earum voluptatem facere provident blanditiis velit laboriosam
					pariatur accusamus odio saepe
					cumque dolor qui a dicta ab doloribus consequatur omnis
					corporis cupiditate eaque assumenda ad nesciunt
					"""
			),
			.init(
				id: .init(value: 96),
				userID: .init(value: 10),
				title: "quaerat velit veniam amet cupiditate aut numquam ut sequi",
				body: """
					in non odio excepturi sint eum
					labore voluptates vitae quia qui et
					inventore itaque rerum
					veniam non exercitationem delectus aut
					"""
			),
			.init(
				id: .init(value: 97),
				userID: .init(value: 10),
				title: "quas fugiat ut perspiciatis vero provident",
				body: """
					eum non blanditiis soluta porro quibusdam voluptas
					vel voluptatem qui placeat dolores qui velit aut
					vel inventore aut cumque culpa explicabo aliquid at
					perspiciatis est et voluptatem dignissimos dolor itaque sit nam
					"""
			),
			.init(
				id: .init(value: 98),
				userID: .init(value: 10),
				title: "laboriosam dolor voluptates",
				body: """
					doloremque ex facilis sit sint culpa
					soluta assumenda eligendi non ut eius
					sequi ducimus vel quasi
					veritatis est dolores
					"""
			),
			.init(
				id: .init(value: 99),
				userID: .init(value: 10),
				title: "temporibus sit alias delectus eligendi possimus magni",
				body: """
					quo deleniti praesentium dicta non quod
					aut est molestias
					molestias et officia quis nihil
					itaque dolorem quia
					"""
			),
			.init(
				id: .init(value: 100),
				userID: .init(value: 10),
				title: "at nam consequatur ea labore ea harum",
				body: """
					cupiditate quo est a modi nesciunt soluta
					ipsa voluptas error itaque dicta in
					autem qui minus magnam et distinctio eum
					accusamus ratione error aut
					"""
			),
		]
	}
}

extension Post {
	public static var sample: Self! { [Self].samples.first }
}

extension Array where Element == Post.Connected {
	public static var baseSamples: Self! {
		[Post].samples
			.map({ Element(post: $0) })
	}

	public static var samples: Self! {
		let (withUsers, _) = baseSamples.connectedTo(users: .baseSamples)
		let (_, connected) = [Comment.Connected].baseSamples.connectedTo(posts: withUsers)
		return connected
	}
}

extension Post.Connected {
	public static var sample: Self! { [Self].samples.first }
}
#endif
