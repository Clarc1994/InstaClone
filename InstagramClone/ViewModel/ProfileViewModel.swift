//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//

import UIKit

protocol ProfileViewModelDelegate {
    func updateCV()
    func errorUnfolow(error: Error)
    func errorFollow(error: Error)
    func showEditProfile()
}

final class ProfileViewModel {
    private var user: User
    private var currentUser: User?
    private var posts: [Post]
    private var statsPost: [StatsPost]
    private var followersUser = [User]()
    var delegate: ProfileViewModelDelegate?
    
    init(user: User) {
        self.user = user
        self.posts = [Post]()
        self.statsPost = [StatsPost]()
    }
    
    func getFollowersUser(index: Int) -> User {
        return followersUser[index]
    }
    
    func getSizeFollowersUser() -> Int {
        return followersUser.count
    }
    
    func getStatPost(index: Int) -> StatsPost {
        return statsPost[index]
    }
    
    func getUsername() -> String {
        return user.username
    }
    
    func getSizePosts() -> Int {
        return posts.count
    }
    
    func getRecordInPosts(index: Int) -> Post {
        return posts[index]
    }
    
    func getUser() -> User {
        return user
    }
    
     func checkIfUserIsFollowed() {
         UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
             self.user.isFollowed = isFollowed
             self.delegate?.updateCV()
         }
     }
     
     func fetchUserStats() {
         UserService.fetchUserStats(uid: user.uid) { userStats in
             self.user.stats = userStats
             self.delegate?.updateCV()
         }
     }
    
     func fetchPosts() {
         PostService.fetchPosts(ForUser: user.uid) { posts in
             self.posts = posts
             self.setStatsPosts(posts: posts)
             self.delegate?.updateCV()
         }
     }
    
    func setStatsPosts(posts: [Post]) {
        for(_, element) in posts.enumerated() {
            statsPost.append(StatsPost(like: element.likes, comment: element.comments, time: element.timestamp, imageUrl: element.imageUrl))
        }
    }
    
    func fetchFollowersUsers() {
        UserService.fetchUserFollowers(uid: user.uid) { users in
            self.followersUser = users
        }
    }
     
    func buttonHeaderAction() {
        if user.isCurrentUser {
            delegate?.showEditProfile()
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                if let error = error {
                    self.delegate?.errorUnfolow(error: error)
                    return
                }
                self.user.isFollowed = false
                self.delegate?.updateCV()
                PostService.updateUserFeedAfterFollowing(user: self.user, didFollow: false)
                self.delegate?.updateCV()
                print("unfolow git")
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                if let error = error {
                    self.delegate?.errorFollow(error: error)
                    return
                }
                self.user.isFollowed = true
                if let currentUser = self.currentUser {
                    NotificationService.uploadNotification(toUid: self.user.uid, fromUser: currentUser, type: .follow)
                }
                PostService.updateUserFeedAfterFollowing(user: self.user, didFollow: true)
                self.delegate?.updateCV()
                print("folow git")
            }
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = AuthService.getUid() else { return  }
        UserService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    func getImageURLPostCell(index: Int) ->URL?{
        return URL(string: posts[index].imageUrl)
    }
}
