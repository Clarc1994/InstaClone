//
//  ResetPasswordController.swift
//  InstagramClone
//
//  Created by A1398 on 09/09/2024.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func returnPrevController()
}

final class ResetPasswordController: UIViewController {
    // MARK: - Properties

    private var viewModel: ResetPasswordViewModel
    weak var delegate: ResetPasswordControllerDelegate?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDissmis), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (email: String?) {
        viewModel = ResetPasswordViewModel(email: email)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        viewModel.delegate = self
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        viewModel.resetPassword(email: email)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.text = viewModel.email
        updateForm()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack=UIStackView(arrangedSubviews: [emailTextField,
                                                 resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
    @objc func handleDissmis() {
        delegate?.returnPrevController()
    }
    func showMessageSuccessResetPassword(widthTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.returnPrevController()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - ResetPasswordViewModelDelegate

extension ResetPasswordController: ResetPasswordViewModelDelegate {
    func successResetPassword() {
       showMessageSuccessResetPassword(widthTitle: "Success", message: "We sent a link to your email to reset you password")
    }
    
    func errorResetPassword(error: Error) {
        showMessage(widthTitle: "Error", message: error.localizedDescription)
        showLoader(false)
    }
}
