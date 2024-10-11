//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by A1398 on 05/08/2024.
//

import UIKit

final class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    var imageUrl: URL? { didSet { configure() } }
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image =  #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        postImageView.sd_setImage(with: imageUrl)
    }
}
