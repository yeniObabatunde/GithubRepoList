//
//  GithubUserRepoListRepository.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

protocol IGithubUserRepoListRepository {
    func getRepoList(completion: @escaping (Result<[RepoItem], Error>) -> Void)
}

class GithubUserRepoListRepository: IGithubUserRepoListRepository {
    fileprivate var remoteDataSource: INetworkService
    
    init(remoteDataSource: INetworkService) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getRepoList(completion: @escaping (Result<[RepoItem], any Error>) -> Void) {
        let baseURL = Constants.ApiHelper.baseURL
        let route = Route.repository.description
        
        Logger.printIfDebug(data: "URL: \(baseURL + route)", logType: .info)
        
        remoteDataSource.fetch(baseUrl: baseURL, route: route, method: .get, type: [RepoItem].self, parameters: nil) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                Logger.printIfDebug(data: "Error: \(failure)", logType: .error)
                completion(.failure(failure))
            }
        }
    }
}
