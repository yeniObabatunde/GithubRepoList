//
//  UserRepoListViewModel.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import Foundation

protocol IUserRepoListViewModel {
    var currentPage: Int {get set}
    var itemsPerPage: Int {get set}
    var isLoadingMore: Bool {get set}
    var canLoadMore: Bool {get set}
    var perPage: Int { get set }
    var repoModel: [RepoItem] {get set}
    var allRepoData: [RepoItem] {get set}
    var showRepoResults: ((Bool) -> Void)? {get set}
    var showError: ((Error) -> Void)? { get set }
    func getRepoList()
    func loadMoreRepositories(page: Int, perPage: Int, completion: @escaping (Bool) -> Void)
    func showCachedRepoList()
}

final class UserRepoListViewModel: IUserRepoListViewModel {
    
    var perPage: Int = 0
    var currentPage = 1
    var itemsPerPage = 20
    var isLoadingMore: Bool = false
    var canLoadMore = true
    var repoModel: [RepoItem] = [RepoItem]()
    var showRepoResults: ((Bool) -> Void)?
    var repoReposit: ((Bool) -> Void)?
    var showError: ((Error) -> Void)?
    var allRepoData: [RepoItem] = []
    private let cacheManager = RepoCacheManager.shared
    private var isFetchingFromNetwork = false
    
    fileprivate var userRepoListRepository: IGithubUserRepoListRepository
    
    init(userRepoRepository: IGithubUserRepoListRepository) {
        self.userRepoListRepository = userRepoRepository
    }
    
    func showCachedRepoList() {
            if let cachedData = cacheManager.getCachedRepositories() {
                self.allRepoData = cachedData
                self.repoModel = Array(cachedData.prefix(self.itemsPerPage))
                self.canLoadMore = cachedData.count > self.itemsPerPage
                self.showRepoResults?(true)
            }
        }
    
    func getRepoList() {
        isFetchingFromNetwork = true
        userRepoListRepository.getRepoList { [weak self] result in
            guard let self = self else { return }
            self.isFetchingFromNetwork = false
            switch result {
            case .success(let data):
                self.allRepoData = data
                self.repoModel = Array(data.prefix(self.itemsPerPage))
                self.canLoadMore = data.count > self.itemsPerPage
                self.showRepoResults?(true)
                
                self.cacheManager.cacheRepositories(data)
            case .failure(let failure):
                if self.allRepoData.isEmpty {
                    self.showError?(failure)
                }
            }
        }
    }
    
    func loadMoreRepositories(page: Int, perPage: Int, completion: @escaping (Bool) -> Void) {
        guard !isLoadingMore && canLoadMore else {
            completion(false)
            return
        }
        
        isLoadingMore = true
        let startIndex = (page - 1) * perPage
        let endIndex = min(startIndex + perPage, allRepoData.count)
        
        guard startIndex < allRepoData.count else {
            canLoadMore = false
            completion(false)
            return
        }
        
        let nextPageData = Array(allRepoData[startIndex..<endIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.repoModel.append(contentsOf: nextPageData)
            self.canLoadMore = endIndex < self.allRepoData.count
            self.showRepoResults?(true)
            self.isLoadingMore = false
            completion(true)
        }
    }
    
}
