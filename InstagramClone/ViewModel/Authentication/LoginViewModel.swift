//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//

import UIKit

protocol LoginViewModelDelegate {
    func successLogin()
    func errorLogin(error: Error)
}

final class LoginViewModel: AuthenticationViewModel {
    var delegate: LoginViewModelDelegate?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return  formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.8)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    func loginUser(email: String, password: String) {
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.delegate?.errorLogin(error: error)
            } else {
                self.delegate?.successLogin()
            }
        }
    }
}
