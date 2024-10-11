//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 17/09/2024.
//

import Foundation
import UIKit

protocol FeedViewModelDelegate {
    func updateCV()
    func endRefreshing()
    func successWantsToShowProfileFor(user: User)
    func successLikePost(cell: FeedCell, didLike post: Post)
    func successUnlikePost(cell: FeedCell, didLike post: Post)
    func successSignOut()
    func errorSignOut()
}

final class FeedViewModel {
    var correntUser: User?
    private var posts = [Post]()
    private var post: Post?
    var delegate: FeedViewModelDelegate?
    
    func fetchPosts() {
        guard post == nil else { return }
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.delegate?.updateCV()
            self.checkIfUserLikedPost()
            self.delegate?.endRefreshing()
        }
    }
    
    func fetchCorrentUser() {
        guard let uid = AuthService.getUid() else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.correntUser = user
        }
    }
    
    func handleRefresh() {
        posts.removeAll()
        delegate?.updateCV()
        fetchPosts()
    }
    
    func checkIfUserLikedPost() {
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId}) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
        delegate?.updateCV()
    }
    
    func getPost() -> Post? {
        return post
    }
    
    func getCorrentUser() -> User? {
        return correntUser
    }
    
    func setCorrentUser(correntUser: User) {
        self.correntUser = correntUser
    }
    
    func getPosts(index: Int) -> Post {
        return posts[index]
    }
    
    func getSizePosts() -> Int {
        if post == nil {
            return posts.count
        } else {
            return 1
        }
    }
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func wantsToShowProfileFor(uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            self.delegate?.successWantsToShowProfileFor(user: user)
        }
    }

    func didLike(cell: FeedCell, didLike post: Post) {
        guard let user = correntUser else { return }
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                self.delegate?.successUnlikePost(cell: cell, didLike: post)
            }
        } else {
            PostService.likePost(post: post) { error in
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
                
                self.delegate?.successLikePost(cell: cell, didLike: post)
            }
        }
    }
    
    func handleLogout() {
        AuthService.signOut { result in
            switch result {
            case .success:
                self.delegate?.successSignOut()
            case .failure:
                self.delegate?.errorSignOut()
            }
        }
    }
}
