//
//  UserCellViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 09/08/2024.
//

import Foundation

final class UserCellViewModel {
    private let user: User
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var userName: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    init(user: User){
        self.user = user
    }
}
