
//
//  FeedPostViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 3/10/2024.
//

import Foundation
import UIKit

protocol FeedPostViewModelDelegate {
    func successWantsToShowProfileFor(user: User)
    func successWantsToShowComment(correntUser: User)
    func successUnlikePost()
    func successLikePost()
    func confUI()
}

final class FeedPostViewModel {
    var delegate: FeedPostViewModelDelegate?
    var post: Post
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUsername
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    init (post: Post){
        self.post = post
    }
    
    func incrementCount() {
        post.likes = post.likes + 1
    }
    
    func decrementCount() {
        post.likes = post.likes - 1
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    func wantsToShowProfileFor() {
        UserService.fetchUser(withUid: post.ownerUid) { user in
            self.delegate?.successWantsToShowProfileFor(user: user)
        }
    }
    
    func fetchCorrentUser() {
        guard let uid = AuthService.getUid() else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.delegate?.successWantsToShowComment(correntUser: user)
        }
    }
    
    func wantsToShowCommentsFor() {
        fetchCorrentUser()
    }
    
    func didLike() {
        if post.didLike == true {
            PostService.unlikePost(post: post) { error in
                self.post.didLike.toggle()
                self.decrementCount()
                self.delegate?.successUnlikePost()
            }
        } else {
            guard let uid = AuthService.getUid() else { return }
            UserService.fetchUser(withUid: uid) { user in
                PostService.likePost(post: self.post) { error in
                    NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: user, type: .like, post: self.post)
                    self.post.didLike.toggle()
                    self.incrementCount()
                    self.delegate?.successLikePost()
                }
            }
        }
    }
    
    func checkIfUserLikedPost() {
        PostService.checkIfUserLikedPost(post: post) { didLike in
            self.post.didLike = didLike
            self.delegate?.confUI()
        }
    }
}

