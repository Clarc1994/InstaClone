//
//  CommentService.swift
//  InstagramClone
//
//  Created by A1398 on 23/08/2024.
//

import Firebase

// Skoro wszędzie używasz Firebase, to powinieneś sobie zrobić fasade na to, klase która będzie nakładką na Firebase i użycie tej fasady w serwisach.
struct CommentService {
    static func uploadComment(comment: String, post: Post, user: User, completion: @escaping(FirestoreCompletion)) {
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        COLLECTION_POSTS.document(post.postId).updateData(["comments": post.comments + 1])
        COLLECTION_POSTS.document(post.postId).collection("comments").addDocument(data: data,completion: completion)
    }
    
    static func fetchComment(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        query.addSnapshotListener { (snapshot, error)  in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictonary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
