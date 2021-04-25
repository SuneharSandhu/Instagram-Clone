//
//  NotificationLikeEventTableViewCell.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/18/21.
//

import UIKit
import SDWebImage

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: UserNotification)
}

class NotificationLikeEventTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .tertiarySystemBackground
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0 // line wrap
        label.text = "@joe liked your photo"
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        addSubview(profileImageView)
        addSubview(label)
        addSubview(postButton)
        
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    @objc private func didTapPostButton() {
        guard let model = model else {
            return
        }
        
        delegate?.didTapRelatedPostButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height-4
        postButton.frame = CGRect(x: contentView.width - 5 - size, y: 2, width: size, height: size)
        
        label.frame = CGRect(x: profileImageView.right + 5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width-16,
                             height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postButton.setBackgroundImage(nil, for: .normal)
        label.text = nil
        profileImageView.image = nil
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(let post):
            let thumbnail = post.thumbnailImage
            postButton.sd_setBackgroundImage(with: thumbnail, for: .normal, completed: nil)
        case .follow:
            break
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
}

