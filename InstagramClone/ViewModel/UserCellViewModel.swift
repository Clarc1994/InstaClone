//
//  UserCellViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 09/08/2024.
//

import Foundation

// Mylisz pojęcie ViewModel -> ViewModel to jest klasa, która zarządza logiką biznesową kontrolera. 
// Cellka to ma swój model, a nie ViewModel. I taki model proponuje konstruować w ten sposób: 
extension UserCell {

    struct Data {

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
    
        init(user: User) {
            self.user = user
        }

    }

}


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
