//
//  UserRepoSceneDIContainer.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

class UserRepoSceneDIContainer {
    
    static let sharedInstance = UserRepoSceneDIContainer()
    
    func makeUserRepoFlowCoordinator(navigationController: UINavigationController) -> UserRepoListCoordinator {
        return UserRepoListCoordinator(navigationController: navigationController)
    }
    
    func makeUserRepoListRepository() -> IGithubUserRepoListRepository {
        let networkService = AppDIContainer.makeNetworkService()
        return GithubUserRepoListRepository(remoteDataSource: networkService)
    }
    
    func makeUserDetailsViewController() -> UserDetailsViewController {
        return UserDetailsViewController()
    }
    
    func makeRepoListViewController() -> GithubRespositoryListViewController {
        let vc = GithubRespositoryListViewController()
        let serviceRepo = makeUserRepoListRepository()
        vc.userRepoViewModel = UserRepoListViewModel(userRepoRepository: serviceRepo)
        return vc
    }
}
