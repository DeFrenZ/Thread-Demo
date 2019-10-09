import UIKit
import SwiftUI

final class SceneDelegate: UIResponder {
	var window: UIWindow?
}

extension SceneDelegate: UISceneDelegate {
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else { return }

		let window = UIWindow(windowScene: windowScene)
		let rootView = RootView()
		let rootViewController = UIHostingController(rootView: rootView)
		window.rootViewController = rootViewController
		self.window = window

		window.makeKeyAndVisible()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}
