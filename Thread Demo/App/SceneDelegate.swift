import UIKit
import SwiftUI
import Core
import Log

final class SceneDelegate: UIResponder {
	var window: UIWindow?
}

extension SceneDelegate: UISceneDelegate {
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		LoggingSystem.bootstrap()

		#if DEBUG
		guard NSClassFromString("XCTest") == nil else { return }
		#endif

		guard let windowScene = scene as? UIWindowScene else { return }

		// TODO: Move to somewhere where all scenes share the same data
		let dataStore = DataStore(api: .init())

		let window = UIWindow(windowScene: windowScene)
		let rootView = RootView()
			.environmentObject(DataUIStore(dataStore))
		let rootViewController = UIHostingController(rootView: rootView)
		window.rootViewController = rootViewController
		self.window = window

		window.makeKeyAndVisible()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}
