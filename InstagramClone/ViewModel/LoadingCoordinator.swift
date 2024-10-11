//
//  LoadingCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 30/09/2024.
//

import Foundation

protocol LoadingCoordinatorDelegate {
    func showTabBarController(user: User?, child: Coordinator)
    func showLoginController(child: Coordinator)
}

final class LoadingCoordinator: BaseCoordinator {
    var delegate: LoadingCoordinatorDelegate?
    
    func start() {
        let controller = LoadingController()
        controller.delegate = self
        router.push(viewController: controller)
    }
}

extension LoadingCoordinator: LoadingControllerDelegate {
    func navigateToLoginController() {
        delegate?.showLoginController(child: self)
    }
    
    func navigateToTabBarController(user: User?) {
        delegate?.showTabBarController(user: user, child: self)
    }
}
