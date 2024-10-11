//
//  LoginCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 30/09/2024.
//

import Foundation

protocol LoginCoordinatorDelegate {
    func showLoadingController(child: Coordinator)
}

final class LoginCoordinator: BaseCoordinator {
    var delegate: LoginCoordinatorDelegate?
    
    func start() {
        let controller = LoginController()
        controller.delegate = self
        router.setRootModule(viewController: controller)
    }
}

extension LoginCoordinator: LoginControllerDelegate {
    func navigateToResetController(email: String) {
        let child = ResetCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(email: email)
    }
    
    func navigateToRegistrationController() {
        let child = RegistrationCoordinator(router: router)
        childCoordinators.append(child)
        child.start()
    }
    
    func navigateToLoading() {
        delegate?.showLoadingController(child: self)
    }
}

extension LoginCoordinator: RegistrationCoordinatorDelegate {
    func returnFromRegistrationController(_ child: BaseCoordinator) {
        removeChildCoordinator(child)
    }
}

extension LoginCoordinator: ResetCoordinatorDelegate {
    func returnPrevController(_ child: BaseCoordinator) {
        removeChildCoordinator(child)
    }
}
