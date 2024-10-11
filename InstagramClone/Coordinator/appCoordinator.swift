//
//  appCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    func start() {
        let child = LoadingCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start()
    }
}

extension AppCoordinator: LoadingCoordinatorDelegate {
    func showLoginController(child: Coordinator) {
        removeChildCoordinator(child)
        let childlogin = LoginCoordinator(router: router)
        childlogin.delegate = self
        childCoordinators.append(childlogin)
        childlogin.start()
    }
    
    func showTabBarController(user: User?, child: Coordinator) {
        removeChildCoordinator(child)
        let childTab = MainTabCoordinator(router: router)
        childTab.delegate = self
        childCoordinators.append(childTab)
        childTab.start(user: user!)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func showLoadingController(child: Coordinator) {
        removeChildCoordinator(child)
        start()
    }
}

extension AppCoordinator: MainTabCoordinatorDelegate {
    func showLoadingControllerFromMTC(child: Coordinator) {
        removeChildCoordinator(child)
        start()
    }
}
