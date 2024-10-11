//
//  LoadingController.swift
//  InstagramClone
//
//  Created by A1398 on 30/09/2024.
//

import Foundation
import UIKit

protocol LoadingControllerDelegate {
    func navigateToLoginController()
    func navigateToTabBarController(user: User?)
}

final class LoadingController: UIViewController {
    // MARK: - Properties
    var delegate: LoadingControllerDelegate?
    private var viewModel = LoadingViewModel()
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureUI()
        viewModel.checkIfUserIsLoggedIn()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.centerY(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
    }
}

extension LoadingController: LoadingViewModelDelegate {
    func showTabBarController(user: User?) {
        delegate?.navigateToTabBarController(user: user)
    }
    
    func showLoginController() {
        delegate?.navigateToLoginController()
    }
}
