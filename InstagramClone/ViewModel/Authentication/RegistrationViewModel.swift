//
//  RegistrationViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//
import UIKit

protocol RegistrationViewModelDelegate {
    func successRegistration()
    func errorRegistration(error: Error)
}

final class RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var delegate: RegistrationViewModelDelegate?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return  formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.8)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    func registration(credientials: AuthCredentials) {
        AuthService.registerUser(withCredential: credientials) { error in
            if let error = error {
                self.delegate?.errorRegistration(error: error)
            } else {
                self.delegate?.successRegistration()
            }
        }
    }
}
