//
//  ImageSelectorController.swift
//  InstagramClone
//
//  Created by A1398 on 02/04/2024.
//


import UIKit
import YPImagePicker

protocol ImageSelectorControllerDelegate {
    func navigateToUploadPostController(user:User, selectedImage: UIImage)
    func selectMainTab()
}

final class ImageSelectorController: UIViewController {
    var runSelectImage: Bool
    var viewModel: ImageSelectorViewModel
    var delegate: ImageSelectorControllerDelegate?
    
    init(user:User) {
        viewModel = ImageSelectorViewModel(user: user)
        runSelectImage = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        runSelectImage = false
        selectImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if runSelectImage == true {
            selectImage()
        }
    }
    
    func selectImage() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        didFinishPickingMedia(picker)
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled  in
            if cancelled {
                self.delegate?.selectMainTab()
                self.dismiss(animated: false)
                return
            }
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                self.delegate?.navigateToUploadPostController(user: self.viewModel.getUser(), selectedImage: selectedImage)
            }
        }
    }
}
