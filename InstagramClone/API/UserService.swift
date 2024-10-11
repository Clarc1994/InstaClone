//
//  UserService.swift
//  InstagramClone
//
//  Created by A1398 on 07/08/2024.
//

import Firebase
import CoreMedia
import UIKit
typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            print("test 12 fechUserService")
            if let error = error {
                print("test 13 fechUserService")
                print(error)
            }
            guard let dictonary = snapshot?.data() else { return }
            let user = User(dictonary: dictonary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map( { User(dictonary: $0.data())})
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func fetchUserFollowers(uid: String, completion: @escaping([User]) -> Void){
        var followersUid = [String]()
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                followersUid.append(document.documentID)
              }
            let group = DispatchGroup()
            var followersUser = [User]()
            for(_, element) in followersUid.enumerated() {
                print("BBB \(element)")
                group.enter()
                fetchUser(withUid: element) { user in
                    followersUser.append(user)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(followersUser)
            }
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void ) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void ) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following, posts: posts))
                }
            }
        }
    }
}
