//
//  Post.swift
//  InstagramClone
//
//  Created by A1398 on 19/08/2024.
//

import Firebase

struct Post {
    
    var caption: String
    var likes: Int
    var comments: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    let ownerUsername: String
    let ownerImageUrl: String
    var didLike = false
    
    init(postId: String, dictonary: [String: Any]) {
        self.postId = postId
        self.caption = dictonary["caption"] as? String ?? ""
        self.likes = dictonary["likes"] as? Int ?? 0
        self.comments = dictonary["comments"] as? Int ?? 0
        self.imageUrl = dictonary["imageUrl"] as? String ?? ""
        self.timestamp = dictonary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictonary["ownerUid"] as? String ?? ""
        self.ownerUsername = dictonary["ownerUsername"] as? String ?? ""
        self.ownerImageUrl = dictonary["ownerImageUrl"] as? String ?? ""
    }
}
