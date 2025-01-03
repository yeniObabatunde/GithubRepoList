//
//  GithubRespositoryListViewController+Extensions.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

extension GithubRespositoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = UserTableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .userList:
            let userCount = userRepoViewModel?.repoModel.count
            if userCount == 0 {
                setupEmptyState(tableView, string: Constants.Strings.loadingData)
            } else {
                repositoryTableView.backgroundView = nil
                repositoryTableView.separatorStyle = .singleLine
            }
            return userCount ?? 0
        case .loader:
            let hasData = (userRepoViewModel?.repoModel.count ?? 0) > 0
                       let hasMoreData = (userRepoViewModel?.repoModel.count ?? 0) >= userRepoViewModel?.perPage ?? 10
                       return (hasData && hasMoreData) ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = UserTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .userList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserRepoListTableViewCell.reuseIdentifier, for: indexPath) as? UserRepoListTableViewCell else {
                return UITableViewCell()
            }
            let item = userRepoViewModel?.repoModel ?? []
            cell.setupCell(with: item[indexPath.row])
            cell.accessoryType = .disclosureIndicator
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.loaderCell, for: indexPath)
            cell.textLabel?.text = Constants.Strings.loadData
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemBlue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension GithubRespositoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserTableSection(rawValue: indexPath.section) else { return }
        switch section {
        case .userList:
            tableView.deselectRow(at: indexPath, animated: true)
            let items = userRepoViewModel?.repoModel ?? []
            let selectedItem = items[indexPath.row]
            userRepoCoordinator?.showDetailsForUser(selectedItem)
        case .loader:
            tableView.deselectRow(at: indexPath, animated: false)
            userRepoViewModel?.perPage += 10
            if userRepoViewModel?.perPage ?? 10 >= 100 {
                return
            } else {
                showLoading()
                userRepoViewModel?.loadMoreRepositories(page: userRepoViewModel?.currentPage ?? 0, perPage: userRepoViewModel?.perPage ?? 0, completion: { sucess in
                    if sucess {
                        DispatchQueue.main.async { [weak self] in
                            self?.hideLoading()
                            self?.repositoryTableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
}
