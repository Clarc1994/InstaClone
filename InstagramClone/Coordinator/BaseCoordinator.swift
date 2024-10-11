//
//  BaseCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var router: Router { get }
}

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func removeChildCoordinator(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
