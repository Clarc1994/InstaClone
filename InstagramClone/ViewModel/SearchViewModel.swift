//
//  SearchViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 12/09/2024.
//
import Foundation

protocol SearchViewModelDelegate {
    func updateCV()
    func updateTV()
}

final class SearchViewModel {
    private var users = [User]()
    private var filteredUsers = [User]()
    private var posts = [Post]()
    var delegate: SearchViewModelDelegate?
    
    func getPosts(index: Int) -> Post {
        return posts[index]
    }
    
    func getUser(index: Int) -> User {
        return users[index]
    }
    
    func getFilteredUsers(index: Int) -> User {
        return filteredUsers[index]
    }
    
    func getSizeUsers() -> Int {
        return users.count
    }
    
    func getSizePosts() -> Int {
        return posts.count
    }
    
    func getSizeFilteredUsers() -> Int {
        return filteredUsers.count
    }
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.delegate?.updateCV()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.delegate?.updateCV()
        }
    }
    
    func filterUser(searchText: String?) {
        guard let searchText = searchText else { return }
        filteredUsers = users.filter( { $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText) } )
        delegate?.updateTV()
    }
    
    func getPostImageUrl(index: Int) -> URL? {
        return URL(string: posts[index].imageUrl)
    }
}
