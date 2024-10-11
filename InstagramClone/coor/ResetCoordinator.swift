//
//  ResetCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 11/10/2024.
//

import Foundation

protocol ResetCoordinatorDelegate {
    func returnPrevController(_ child: BaseCoordinator)
}

final class ResetCoordinator: BaseCoordinator {
    var delegate: ResetCoordinatorDelegate?
    func start(email: String) {
        let controller = ResetPasswordController(email: email)
        controller.delegate = self
        router.push(viewController: controller)
    }
}

extension ResetCoordinator: ResetPasswordControllerDelegate {
    func returnPrevController() {
        router.pop()
        delegate?.returnPrevController(self)
    }
}
