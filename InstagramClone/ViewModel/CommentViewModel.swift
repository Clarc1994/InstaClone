//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 16/09/2024.
//

import Foundation

protocol CommentViewModelDelegate {
    func updateCV()
    func showProfile(user: User)
    func succesUploadCommentAndNotification(inputView: CommentInputAccesoryView)
}

final class CommentViewModel {
    // MARK: - Properties
    private let post: Post
    private var comments = [Comment]()
    var delegate: CommentViewModelDelegate?
    var correntUser: User
    
    init (post: Post, correntUser: User) {
        self.post = post
        self.correntUser = correntUser
    }
    
    // MARK: - Methods
    
    func getCorrentUser() -> User {
        return correntUser
    }
    
    func getSizeComments() -> Int {
        return comments.count
    }
    
    func getComment(index: Int) -> Comment {
        return comments[index]
    }
    
    func fetchComments() {
        CommentService.fetchComment(forPost: post.postId) { comments in
            self.comments = comments
            self.delegate?.updateCV()
        }
    }
    
    func fetchUser(index: Int) {
        let uid = comments[index].uid
        UserService.fetchUser(withUid: uid) { user in
            self.delegate?.showProfile(user: user)
        }
    }
    
    func uploadCommentAndNotification(inputView: CommentInputAccesoryView, comment: String, correntUser: User) {
        CommentService.uploadComment(comment: comment, post: post, user: correntUser) { error in
            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: correntUser, type: .comment, post: self.post)
            self.delegate?.succesUploadCommentAndNotification(inputView: inputView)
        }
    }
}
