//
//  Constans.swift
//  InstagramClone
//
//  Created by A1398 on 07/08/2024.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")

struct K {
    struct Cell {
        static let headerIdentifier = "ProfileHeader"
        static let cellProfileIdentifier = "ProfileCell"
        static let postCellIdentifier = "ProfileCell"
        static let userCellIdentifier = "UserCell"
        static let NotificationCellIdentifier = "NotificationCell"
        static let commentCellIdentifier = "CommentCell"
        static let FeedCellIdentifier = "FeedCell"
        static let postCellProfileIdentifier = "PostCell"
        static let userCellProfileIdentifier = "UserCellProfile"
    }
    
    
    
}
