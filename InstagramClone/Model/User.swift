//
//  User.swift
//  InstagramClone
//
//  Created by A1398 on 07/08/2024.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    var isFollowed = false
    var stats: UserStats!
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictonary: [String: Any]) {
        self.email = dictonary["email"] as? String ?? ""
        self.fullname = dictonary["fullname"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.username = dictonary["username"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
