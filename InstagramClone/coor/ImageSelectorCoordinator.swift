//
//  ImageSelectorCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 30/09/2024.
//

import Foundation
import UIKit

protocol ImageSelectorCoordinatorDelegate {
    func selectMainTabBar()
}

final class ImageSelectorCoordinator: BaseCoordinator {
    var delegate: ImageSelectorCoordinatorDelegate?
}

extension ImageSelectorCoordinator: ImageSelectorControllerDelegate {
    func selectMainTab() {
        delegate?.selectMainTabBar()
    }
    
    func navigateToUploadPostController(user: User, selectedImage: UIImage) {
        let child = UploadPostCoordinator(router: router)
        child.delegate = self
        childCoordinators.append(child)
        child.start(user: user, selectedImage: selectedImage)
    }
}

extension ImageSelectorCoordinator: UploadPostCoordinatorDelegate {
    func returnFromUploadPost(child: Coordinator) {
        removeChildCoordinator(child)
        delegate?.selectMainTabBar()
    }
}
