//
//  NotificationViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 13/09/2024.
//

import Foundation

protocol NotificationViewModelDelegate {
    func updateTV()
    func successFetchUser(user: User)
    func successFollowAndUnfollow(_ cell: NotificationCell)
    func showPost(post: Post)
}

final class NotificationViewModel {
    private var notifications = [Notification]()
    var delegate: NotificationViewModelDelegate?

    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.delegate?.updateTV()
            self.checkIfUserIsFollowed()
        }
    }
     
    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                    self.delegate?.updateTV()
                }
            }
        }
    }
    
    func removeNotifications() {
        notifications.removeAll()
    }
    
    func getSizeNotifications() -> Int {
        return notifications.count
    }
    
    func getNotification(index: Int) -> Notification{
        return notifications[index]
    }
    
    func fetchUser(index: Int) {
        let uid = notifications[index].uid
        UserService.fetchUser(withUid: uid) { user in
            self.delegate?.successFetchUser(user: user)
        }
    }
    
    func follow(_ cell: NotificationCell, uid: String) {
        UserService.follow(uid: uid) { _ in
            self.delegate?.successFollowAndUnfollow(cell)
        }
        self.fetchNotifications()
    }
    
    func unfollow(_ cell: NotificationCell, uid: String) {
        print("bb")
        UserService.unfollow(uid: uid) { _ in
            self.delegate?.successFollowAndUnfollow(cell)
        }
        self.fetchNotifications()
    }
    
    func viewToPost(postId: String) {
        PostService.fetchPost(withPostId: postId) { post in
            self.delegate?.showPost(post: post)
        }
    }
}
