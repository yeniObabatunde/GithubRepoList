//
//  UserDetailsViewController.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

class UserDetailsViewController: BaseViewController {
    
    private lazy var userIcon: CachedImageView = {
        let userImage = CachedImageView()
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = 100
        userImage.clipsToBounds = true
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 10
        userImage.layer.borderColor = UIColor.systemBlue.cgColor
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(systemName: "person.circle")
        return userImage
    }()
    
    private lazy var userIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userUrlLabel: UILabel = {
        let userUrlLabel = UILabel()
        userUrlLabel.textAlignment = .center
        userUrlLabel.numberOfLines = 0
        userUrlLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        userUrlLabel.translatesAutoresizingMaskIntoConstraints = false
        return userUrlLabel
    }()
    
    private lazy var nodeIDLabel: UILabel = {
        let nodeIDLabel = UILabel()
        nodeIDLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nodeIDLabel.translatesAutoresizingMaskIntoConstraints = false
        return nodeIDLabel
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type: "
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedModel: RepoItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func configureViews() {
        super.configureViews()
        view.addSubviews(userIcon, userIDLabel, userNameLabel, userTypeLabel, nodeIDLabel, userUrlLabel)
        guard let model = selectedModel else { return }
        title = model.owner?.login
        setUpViewWithSelectedRepoItem(model)
        addConstraints()
    }
    
    fileprivate func setUpViewWithSelectedRepoItem(_ item: RepoItem) {
        if let imageURL = item.owner?.avatarURL {
            userIcon.fetchImage(with: imageURL)
        } else {
            userIcon.image = UIImage(systemName: "person.circle")
        }
        userIDLabel.text = "ID: \(item.id ?? 0)"
        userNameLabel.text = "USERNAME: \(item.owner?.login ?? "no user name")"
        userTypeLabel.text = "USER TYPE: \(item.owner?.type?.rawValue ?? "no user type")"
        nodeIDLabel.text = "NODE ID: \(item.nodeID ?? "no node ID")"
        userUrlLabel.text = "USER URL: \(item.htmlURL ?? "no user URL")"
    }
    
    fileprivate func addConstraints() {
        userIcon.centerInView(centerX: view.centerXAnchor, top: view.safeAreaLayoutGuide.topAnchor, margin: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 200))
        userIDLabel.centerInView(centerX: view.centerXAnchor, top: userIcon.bottomAnchor, margin: .init(top: 15, left: 10, bottom: 0, right: 10))
        nodeIDLabel.centerInView(centerX: view.centerXAnchor, top: userIDLabel.bottomAnchor, margin: .init(top: 10, left: 0, bottom: 0, right: 10))
        userNameLabel.centerInView(centerX: view.centerXAnchor, top: nodeIDLabel.bottomAnchor, margin: .init(top: 10, left: 10, bottom: 0, right: 10))
        userTypeLabel.centerInView(centerX: view.centerXAnchor, top: userNameLabel.bottomAnchor, margin: .init(top: 10, left: 0, bottom: 0, right: 10))
        userUrlLabel.centerInView(centerX: view.centerXAnchor, top: userTypeLabel.bottomAnchor, margin: .init(top: 10, left: 0, bottom: 0, right: 0))
        userUrlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        userUrlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
}
