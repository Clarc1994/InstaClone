//
//  UploadPostViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 11/09/2024.
//

import UIKit

protocol UploadPostViewModelDelegate {
    func successUploadPost()
    func errorUploadPost(error: Error)
}

final class UploadPostViewModel {
    var currentUser: User?
    var delegate: UploadPostViewModelDelegate?
    
    init(user: User?) {
        self.currentUser = user
    }
    
    func uploadPost(caption: String, image: UIImage, user: User) {
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            if let error = error {
                self.delegate?.errorUploadPost(error: error)
            } else {
                self.delegate?.successUploadPost()
            }
        }
    }
}
