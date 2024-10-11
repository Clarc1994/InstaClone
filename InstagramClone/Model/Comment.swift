//
//  Comment.swift
//  InstagramClone
//
//  Created by A1398 on 23/08/2024.
//

import Firebase

struct Comment {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictonary: [String: Any]) {
        self.uid = dictonary["uid"] as? String ?? ""
        self.username = dictonary["username"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictonary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictonary["comment"] as? String ?? ""
    }
}
