//
//  UserCellProfile.swift
//  InstagramClone
//
//  Created by A1398 on 10/10/2024.
//

import UIKit

final class UserCellProfile: UICollectionViewCell {
    // MARK: - Properties
    var viewModel: UserCellViewModel? { didSet { configure() } }
    
    private let profileimageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "nazwaUzytkownia"
        return label
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Imie Nazwisko"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() {
        addSubview(profileimageView)
        profileimageView.setDimensions(height: 48, width: 48)
        profileimageView.layer.cornerRadius = 48 / 2
        profileimageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: profileimageView, leftAnchor: profileimageView.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        profileimageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = viewModel.userName
        fullnameLabel.text = viewModel.fullname
    }
}
