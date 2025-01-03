//
//  UserRepoListTableViewCell.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

class UserRepoListTableViewCell: UITableViewCell {
    
    fileprivate lazy var avatar: CachedImageView = {
        let userImage = CachedImageView()
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = 20
        userImage.clipsToBounds = true
        userImage.layer.masksToBounds = true
        userImage.configureCacheLimits(memoryLimit: 50, countLimit: 100)
        return userImage
    }()
    
    fileprivate lazy var loginLabel:  UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var userTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViews() {
        addSubviews(avatar, loginLabel, userTypeLabel)
        avatar.layer.cornerRadius = 20
        avatar.anchor(top: topAnchor, leading: leadingAnchor, margin: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        loginLabel.anchor(top: topAnchor, leading: avatar.trailingAnchor, bottom: userTypeLabel.topAnchor, margin: .init(top: 10, left: 10, bottom: 5, right: 0))
        userTypeLabel.anchor(top: loginLabel.bottomAnchor, leading: avatar.trailingAnchor, margin: .init(top: 5, left: 10, bottom: 0, right: 0))
    }
   
    public func setupCell(with model: RepoItem) {
        loginLabel.text = model.name
        userTypeLabel.text = model.owner?.type?.rawValue
        
        if let avatarImage = model.owner?.avatarURL {
            avatar.fetchImage(with: avatarImage)
        } else {
            avatar.image = UIImage(systemName: "person.circle")
        }
    }
    
}
