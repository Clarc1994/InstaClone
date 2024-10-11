//
//  LoadingViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 30/09/2024.
//

import Foundation

protocol LoadingViewModelDelegate {
    func showLoginController()
    func showTabBarController(user: User?)
}

final class LoadingViewModel {
    var delegate: LoadingViewModelDelegate?
    var user: User?
    
    func checkIfUserIsLoggedIn() {
        if AuthService.getCurrentUser() == nil {
            delegate?.showLoginController()
        } else {
            fetchUser()
        }
    }
    
    private func fetchUser() {
        guard let uid = AuthService.getUid() else { return }
                UserService.fetchUser(withUid: uid) { user in
                    self.user = user
                    self.delegate?.showTabBarController(user: user)
        }
    }
}
