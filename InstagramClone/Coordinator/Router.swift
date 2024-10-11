//
//  Router.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import UIKit

final class Router {
     private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func push(viewController: UIViewController, naviationBarHidden: Bool) {
        navigationController?.navigationBar.isHidden = naviationBarHidden
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setRootModule(viewController: UIViewController) {
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func pop(naviationBarHidden: Bool) {
        navigationController?.navigationBar.isHidden = naviationBarHidden
        navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBarHidden(naviationBarHidden: Bool) {
        navigationController?.navigationBar.isHidden = naviationBarHidden
    }
}
