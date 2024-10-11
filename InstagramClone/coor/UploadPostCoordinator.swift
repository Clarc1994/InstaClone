//
//  UploadPostCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 01/10/2024.
//

import Foundation
import UIKit

protocol UploadPostCoordinatorDelegate {
    func returnFromUploadPost(child: Coordinator)
}

final class UploadPostCoordinator: BaseCoordinator {
    var delegate: UploadPostCoordinatorDelegate?
    
    func start(user: User, selectedImage: UIImage) {
        let controller = UploadPostController(user: user)
        controller.selectedImage = selectedImage
        controller.delegate = self
        router.push(viewController: controller, naviationBarHidden: false)
    }
}

extension UploadPostCoordinator: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        delegate?.returnFromUploadPost(child: self)
        router.pop(naviationBarHidden: true)
    }
}
