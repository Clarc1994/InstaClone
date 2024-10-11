//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by A1398 on 16/08/2024.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

final class UploadPostController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    private var viewModel: UploadPostViewModel
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds =  true
        return iv
    }()
    
    private lazy var captionTextView: InputTextFieldView = {
        let tv = InputTextFieldView()
        tv.placeholderText = "Enter caption.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.placeholderShouldCenter = false
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: - constructor
    
    init(user: User?) {
        self.viewModel = UploadPostViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        delegate?.controllerDidFinishUploadingPost(self)
    }
    
     @objc func didTapDone() {
         guard let image = selectedImage else { return }
         guard let caption = captionTextView.text else { return }
         guard let user = viewModel.currentUser else { return }
         showLoader(true)
         viewModel.uploadPost(caption: caption, image: image, user: user)
     }
     
    // MARK: - Helpers
    
    func checkMaxLenght(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view?.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               paddingTop: 16,
                               paddingLeft: 12,
                               paddingRight: 12,
                               height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
    }
}

// MARK: - UploadPostViewModelDelegate

extension UploadPostController: UploadPostViewModelDelegate {
    func successUploadPost() {
        delegate?.controllerDidFinishUploadingPost(self)
    }
    
    func errorUploadPost(error: Error) {
        showLoader(false)
        showMessage(widthTitle: "Error", message: "Error adding post.")
        delegate?.controllerDidFinishUploadingPost(self)
    }
}

// MARK: - UITextFieldDelegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLenght(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
