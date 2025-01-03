//
//  GithubRespositoryListViewController.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit
import Network

class GithubRespositoryListViewController: BaseViewController {
    
    var userRepoViewModel: IUserRepoListViewModel?
    weak var userRepoCoordinator: UserRepoListCoordinator?
    var repoModel: RepoItem?
    
    lazy var repositoryTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func configureViews() {
        super.configureViews()
        
        repositoryTableView.register(UserRepoListTableViewCell.self, forCellReuseIdentifier: UserRepoListTableViewCell.reuseIdentifier)
        repositoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifier.loaderCell)
        repositoryTableView.dataSource = self
        repositoryTableView.delegate = self
        updateFooterViewVisibility(isVisible: false)
        view.addSubview(repositoryTableView)
        constrainViews()
        showLoading()
        setupPagination()
        setupPullToRefresh()
        setupNetworkStatusObserver()
        title = "Repo List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarColor()
    }
    
    fileprivate func constrainViews() {
        repositoryTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, margin: .init(top: 10, left: 10, bottom: 0, right: 10))
    }
    
    override func setObservers() {
        userRepoViewModel?.showError = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: Constants.Alert.errorTitle, message: error.localizedDescription, type: .error, action: nil)
            self.hideLoading()
        }
        
        userRepoViewModel?.showRepoResults = { [weak self] show in
            guard let self else { return }
            
            self.hideLoading()
            if show {
                DispatchQueue.main.async {
                    self.updateFooterViewVisibility(isVisible: self.userRepoViewModel?.repoModel.isEmpty ?? false)
                    self.repositoryTableView.reloadData()
                }
            }
            
            if  !show && self.userRepoViewModel?.allRepoData.isEmpty ?? true {
                setupEmptyState(repositoryTableView, string: Constants.Strings.emptyData)
            }
        }
       
    }
    
    private func setupNetworkStatusObserver() {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        self?.userRepoViewModel?.getRepoList()
                    } else {
                        self?.userRepoViewModel?.showCachedRepoList()
                        self?.hideLoading()
                    }
                }
            }
            monitor.start(queue: DispatchQueue.global())
        }
    
    
    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        repositoryTableView.refreshControl = refreshControl
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        userRepoViewModel?.getRepoList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshControl.endRefreshing()
        }
    }
    
    private func createLoadingFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        footerView.isHidden = true
        return footerView
    }
    
    private func setupPagination() {
        repositoryTableView.tableFooterView = createLoadingFooterView()
    }
    
    func setupEmptyState(_ tableView: UITableView, string: String) {
        let emptyLabel = UILabel(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        emptyLabel.text = string
        emptyLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        emptyLabel.textAlignment = .center
        repositoryTableView.backgroundView = emptyLabel
        repositoryTableView.separatorStyle = .none
    }
    
    func updateFooterViewVisibility(isVisible: Bool) {
        if isVisible {
            repositoryTableView.tableFooterView?.isHidden = false
        } else {
            repositoryTableView.tableFooterView?.isHidden = true
        }
    }
    
}
