//
//  UserRepoListCoordinator.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

final class UserRepoListCoordinator: BaseCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        showGitHubRepoList()
    }
    
    func showGitHubRepoList() {
        let vc = UserRepoSceneDIContainer.sharedInstance.makeRepoListViewController()
        vc.userRepoCoordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDetailsForUser(_ item: RepoItem) {
        let vc = UserRepoSceneDIContainer.sharedInstance.makeUserDetailsViewController()
        vc.selectedModel = item
        navigationController?.pushViewController(vc, animated: true)
    }
   
}
