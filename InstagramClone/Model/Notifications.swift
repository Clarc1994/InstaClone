//
//  Notifications.swift
//  InstagramClone
//
//  Created by A1398 on 26/08/2024.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var nofificationMessage: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    var postImageUrl: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let username: String
    var userIsFollowed = false
    
    init(dictonary: [String: Any]) {
        self.timestamp = dictonary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictonary["id"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.postId = dictonary["postId"] as? String ?? ""
        self.postImageUrl = dictonary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictonary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictonary["userProfileImageUrl"] as? String ?? ""
        self.username = dictonary["username"] as? String ?? ""
    }
}
