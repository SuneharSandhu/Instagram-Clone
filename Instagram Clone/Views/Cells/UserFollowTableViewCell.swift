//
//  UserFollowTableViewCell.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/17/21.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}

enum FollowState {
    case following
    case not_following
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private var model: UserRelationship?
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .secondarySystemBackground
        image.layer.masksToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "John"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "@johndoe"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    public func configure(with model: UserRelationship) {
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = model.username
        switch model.type {
        case .following:
            // show unfollow button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.setTitleColor(UIColor.label, for: .normal)
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .not_following:
            // show follow button
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .link
            followButton.setTitleColor(.white, for: .normal)
            followButton.layer.borderWidth = 0
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        selectionStyle = .none
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else { return }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // profile image
        let size = contentView.height-6
        profileImageView.frame = CGRect(
            x: 3,
            y: 3,
            width: size,
            height: size
        )
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        // Button
        // > 500 implies iPad
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        followButton.frame = CGRect(
            x: contentView.width-5-buttonWidth,
            y: (contentView.height-40)/2,
            width: buttonWidth,
            height: 40
        )
        
        // labels
        let labelHeight = contentView.height/2
        nameLabel.frame = CGRect(
            x: profileImageView.right+5,
            y: 0,
            width: contentView.width-8-profileImageView.width-buttonWidth,
            height: labelHeight
        )
        
        usernameLabel.frame = CGRect(
            x: profileImageView.right+5,
            y: nameLabel.bottom,
            width: contentView.width-8-profileImageView.width-buttonWidth,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderWidth = 0
    }
}
