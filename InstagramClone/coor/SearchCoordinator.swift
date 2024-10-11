//
//  SearchCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import Foundation

final class SearchCoordinator: BaseCoordinator {}

extension SearchCoordinator: SearchControllerDelegate {
    func navigateToFeedPostController(post: Post) {
        let child = FeedPostCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(post: post)
    }
    
    func navigateToProfileController(user: User, backButtonHidden: Bool) {
        let child = ProfileCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(user: user, backButtonHidden: backButtonHidden)
    }
}

extension SearchCoordinator: ProfileCoordinatorDelegate {
    func returnToPrevController(child: Coordinator) {
        removeChildCoordinator(child)
    }
}

extension SearchCoordinator: FeedPostCoordinatorDelegate {
    func didFinishFeedPost(child: Coordinator) {
        removeChildCoordinator(child)
    }
}
