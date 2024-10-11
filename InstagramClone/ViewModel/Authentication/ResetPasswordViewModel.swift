//
//  ResetPasswordViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//

import UIKit

protocol ResetPasswordViewModelDelegate {
    func successResetPassword()
    func errorResetPassword(error: Error)
}

final class ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?
    var delegate: ResetPasswordViewModelDelegate?
    var formIsValid: Bool { return email?.isEmpty == false }
    var buttonBackgroundColor: UIColor {
        return  formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.8)
    }
    
    init( email: String?) {
        self.email = email
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    func resetPassword(email: String) {
        AuthService.resetPassword(widthEmail: email) { error in
            if let error = error {
                self.delegate?.errorResetPassword(error: error)
            } else {
                self.delegate?.successResetPassword()
            }
        }
    }
}
