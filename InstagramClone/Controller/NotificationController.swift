//
//  NotificationController.swift
//  InstagramClone
//
//  Created by A1398 on 02/04/2024.
//

import UIKit

protocol NotificationControllerDelegate {
    func navigateToFeedController(post: Post)
    func naviateToProfileController(user:User)
}

final class NotificationController: UITableViewController {
    // MARK: - Properties
    var delegate: NotificationControllerDelegate?
    private var viewModel = NotificationViewModel()
    private let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: Functions
    
    func fetchNotifications() {
        viewModel.fetchNotifications()
    }
    
    func checkIfUserIsFollowed() {
        viewModel.checkIfUserIsFollowed()
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        viewModel.removeNotifications()
        tableView.reloadData()
        viewModel.fetchNotifications()
        refresher.endRefreshing()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: K.Cell.NotificationCellIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}

// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSizeNotifications()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.NotificationCellIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationCellViewModel(notification: viewModel.getNotification(index: indexPath.row))
        cell.delegate = self
        return cell
    }
}
   
// MARK: - UITableViewDelegate

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLoader(true)
        viewModel.fetchUser(index: indexPath.row)
    }
}

// MARK: - NotificationViewModelDelegate

extension NotificationController: NotificationViewModelDelegate {
    func showPost(post: Post) {
        showLoader(false)
        delegate?.navigateToFeedController(post: post)
    }
    
    func successFollowAndUnfollow(_ cell: NotificationCell) {
        self.showLoader(false)
        cell.viewModel?.notification.userIsFollowed.toggle()
    }
    
    func updateTV() {
        tableView.reloadData()
    }
    
    func successFetchUser(user: User) {
        showLoader(false)
        delegate?.naviateToProfileController(user: user)
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        viewModel.follow(cell, uid: uid)
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        showLoader(true)
        viewModel.unfollow(cell, uid: uid)
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        viewModel.viewToPost(postId: postId)
    }
}
