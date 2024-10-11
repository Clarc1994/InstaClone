//
//  FeedCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import UIKit
protocol FeedCoordinatorDelegate {
    func showLoginController(child: Coordinator)
}

final class FeedCoordinator: BaseCoordinator {
    var delegate: FeedCoordinatorDelegate?
    
    func start() {
        let controller = FeedController()
        controller.delegate = self
        router.push(viewController: controller)
    }
}

extension FeedCoordinator: FeedControllerDelegate {

    func navigateCommentController(post: Post, correntUser: User) {
        let child = CommentCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(post: post, correntUser: correntUser)
    }
    
    func navigateToProfileController(user: User, backButtonHidden: Bool) {
        let child = ProfileCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(user: user, backButtonHidden: backButtonHidden)
    }
    
    func navigateToLoginController() {
        delegate?.showLoginController(child: self)
    }
}

extension FeedCoordinator: ProfileCoordinatorDelegate {
    func returnToPrevController(child: Coordinator) {
        removeChildCoordinator(child)
    }
}

extension FeedCoordinator: CommentCoordinatorDelegate {
    func returnFromCommentController(child: Coordinator) {
        removeChildCoordinator(child)
        router.setNavigationBarHidden(naviationBarHidden: true)
    }
}
