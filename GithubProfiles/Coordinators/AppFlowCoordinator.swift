//
//  AppFlowCoordinator.swift
//  GithubProfiles
//
//   Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

final class AppFlowCoordinator: BaseCoordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        showRepoViewController(navigationController: navigationController)
        window.makeKeyAndVisible()
    }
    
    func showRepoViewController(navigationController: UINavigationController) {
        let RepoDIContainer = AppDIContainer.makeUserRepoSceneDIContainer()
        let RepoListFlowCoordinator = RepoDIContainer.makeUserRepoFlowCoordinator(navigationController: navigationController)
        store(coordinator: RepoListFlowCoordinator)
        RepoListFlowCoordinator.start()
    }
    
    deinit {
        print("AppFlowCoordinator removed")
    }
    
}
