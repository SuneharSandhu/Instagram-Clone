//
//  PostViewController.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/10/21.
//

import UIKit

/*
 
 Section
 - Header model
 Section
 - Post cell model
 Section
 - Action Buttons cell model
 Section
 - n Number of general mdoels for comments
 */

/// States of rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) // post
    case actions(provider: String)   // like, comment, share
    case comments(comments: [PostComment])
}

/// Model of rendered Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    private let model: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        table.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        table.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        table.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return table
    }()
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else { return }
        // Header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        // 4 Comments
        var comments = [PostComment]()
        for i in 0..<4 {
            comments.append(
                PostComment(
                    id: "123_\(i)",
                    username: "@dave",
                    text: "Cool post!",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }
    
}

// MARK: - PostViewController Delegate & DataSource
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        case .primaryContent(_): return 1
        case .header(_): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
            return cell
        case .header(let users):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(_): return 60
        case .comments(_): return 50
        case .primaryContent(_):  return tableView.width
        case .header(_): return 70
        }
    }
    
}
