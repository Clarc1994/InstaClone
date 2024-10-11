//
//  FeedPostCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 03/10/2024.
//

import Foundation

protocol FeedPostCoordinatorDelegate {
    func didFinishFeedPost(child: Coordinator)
}

final class FeedPostCoordinator: BaseCoordinator {
    var delegate: FeedPostCoordinatorDelegate?
    
    func start(post:Post) {
        let controller = FeedPostController(post: post)
        controller.delegate = self
        router.push(viewController: controller, naviationBarHidden: false)
    }
}

extension FeedPostCoordinator: FeedPostControllerDelegate {
    func navigateCommentController(post: Post, correntUser: User) {
        let child = CommentCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(post: post, correntUser: correntUser)
    }
    
    func navigateToProfileController(user: User) {
        let child = ProfileCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(user: user, backButtonHidden: false)
    }
    
    func returnToPrevFromFeedPostController() {
        router.pop(naviationBarHidden: true)
        delegate?.didFinishFeedPost(child: self)
    }
}

extension FeedPostCoordinator: ProfileCoordinatorDelegate {
    func returnToPrevController(child: Coordinator) {
        removeChildCoordinator(child)
        router.setNavigationBarHidden(naviationBarHidden: false)
    }
}

extension FeedPostCoordinator: CommentCoordinatorDelegate {
    func returnFromCommentController(child: Coordinator) {
        removeChildCoordinator(child)
        router.setNavigationBarHidden(naviationBarHidden: false)
    }
}
