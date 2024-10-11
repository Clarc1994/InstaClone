//
//  ImageSelectorViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 01/10/2024.
//

import Foundation

final class ImageSelectorViewModel {
    var user: User
        
    init(user: User) {
        self.user = user
    }
    
    func getUser() -> User {
        return user
    }
}
