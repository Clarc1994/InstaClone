//
//  NotificationCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import Foundation

final class NotificationCoordinator: BaseCoordinator {}

extension NotificationCoordinator: NotificationControllerDelegate {
    func navigateToFeedController(post: Post) {
        let child = FeedPostCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(post: post)
    }
    
    func naviateToProfileController(user: User) {
        let child = ProfileCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(user: user, backButtonHidden: false)
    }
}
extension NotificationCoordinator: ProfileCoordinatorDelegate {
    func returnToPrevController(child: Coordinator) {
        removeChildCoordinator(child)
    }
}

extension NotificationCoordinator: FeedPostCoordinatorDelegate {
    func didFinishFeedPost(child: Coordinator) {
        removeChildCoordinator(child)
    }
}
