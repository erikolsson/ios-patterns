//
//  SceneDelegate.swift
//  Patterns
//
//  Created by Erik Olsson on 2022-08-18.
//

import UIKit
import MainApp
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let viewController = AppViewController(store: Store(initialState: App.State(),
                                                        reducer: App()))
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UINavigationController(rootViewController: viewController)
    window.makeKeyAndVisible()
    self.window = window
  }

}

