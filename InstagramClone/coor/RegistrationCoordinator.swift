//
//  RegistrationCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 11/10/2024.
//

import Foundation

protocol RegistrationCoordinatorDelegate {
    func returnFromRegistrationController(_ child: BaseCoordinator)
    
}

final class RegistrationCoordinator: BaseCoordinator {
    var delegate: RegistrationCoordinatorDelegate?
    func start() {
        let controller = RegistrationController()
        controller.delegate = self
        router.push(viewController: controller)
    }
}

extension RegistrationCoordinator: RegistrationControllerDelegate {
    func returnPrevController() {
        delegate?.returnFromRegistrationController(self)
        router.pop()
    }
}
