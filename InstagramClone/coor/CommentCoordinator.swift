//
//  CommentCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import Foundation

protocol CommentCoordinatorDelegate {
    func returnFromCommentController(child: Coordinator)
}

final class CommentCoordinator: BaseCoordinator {
    var delegate: CommentCoordinatorDelegate?
    
    func start(post:Post, correntUser: User) {
        let controller = CommentController(post: post, correntUser: correntUser)
        controller.delegate = self
        router.push(viewController: controller, naviationBarHidden: false)
    }
}

extension CommentCoordinator: CommentControllerDelegate {
    func returnToPrevController() {
        router.pop()
        delegate?.returnFromCommentController(child: self)
    }
    
    func navigateToProfileController(user: User) {}
}
