//
//  AppDIContainer.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

class AppDIContainer {
    
    static func makeNetworkService() -> INetworkService {
        return RemoteNetworkService()
    }
    
    static func makeUserRepoSceneDIContainer() -> UserRepoSceneDIContainer {
        return UserRepoSceneDIContainer.sharedInstance
    }
    
}
