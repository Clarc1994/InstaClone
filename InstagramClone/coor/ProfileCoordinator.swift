//
//  ProfileCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import Foundation

protocol ProfileCoordinatorDelegate {
    func returnToPrevController(child:Coordinator)
}

final class ProfileCoordinator: BaseCoordinator {
    var delegate: ProfileCoordinatorDelegate?
    
    func start(user: User, backButtonHidden: Bool) {
        let controller = ProfileController(user: user, backButtonHidden: backButtonHidden)
        controller.delegate = self
        router.push(viewController: controller, naviationBarHidden: false)
    }
}

extension ProfileCoordinator: ProfileControllerDelegate {
    func navigateToFeedPostController(post: Post) {
        let child = FeedPostCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(post: post)
    }
    
    func returnToPrevController() {
        router.pop(naviationBarHidden: true)
        delegate?.returnToPrevController(child: self)
    }
}

extension ProfileCoordinator: FeedPostCoordinatorDelegate {
    func didFinishFeedPost(child: Coordinator) {
        removeChildCoordinator(child)
    }
}
