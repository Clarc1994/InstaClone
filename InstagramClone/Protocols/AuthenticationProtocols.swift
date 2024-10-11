//
//  AuthenticationProtocols.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//
import Foundation
import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

