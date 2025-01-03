//
//  SceneDelegate.swift
//  GithubProfiles
//
//   Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupCoordinator(for: windowScene)
    }
    
    fileprivate func setupCoordinator(for windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        appCoordinator = AppFlowCoordinator(window: window)
        appCoordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

