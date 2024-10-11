//
//  PostCell.swift
//  InstagramClone
//
//  Created by A1398 on 08/10/2024.
//

import UIKit

final class PostCell: UICollectionViewCell {
    // MARK: - Properties
    var viewModel: PostCellViewModel?
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let likeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "like_unselected")
        iv.setDimensions(height: 25, width: 25)
        return iv
    }()
    
    private let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "comment")
        iv.setDimensions(height: 25, width: 25)
        return iv
    }()
    private let dateImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "calendar2")
        iv.setDimensions(height: 25, width: 25)
        return iv
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = " 14"
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = " 13"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "6 tyg"
        return label
    }()
    
    func configureUI() {
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(left: leftAnchor, paddingLeft: 12, width: 40, height: 40)
        let stackView = UIStackView(arrangedSubviews: [likeImageView, likeLabel,commentImageView, commentLabel, dateImageView,dateLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        stackView.anchor(left: postImageView.rightAnchor,
                     right: rightAnchor,
                     paddingLeft: 12,
                     paddingRight: 12,
                     height: 50)
        postImageView.sd_setImage(with: viewModel?.postImageUrl, completed: nil)
        likeLabel.text =  " \(viewModel?.getLike() ?? "0")"
        commentLabel.text = " \(viewModel?.getComment() ?? "0")"
        dateLabel.text = "\(viewModel?.timestampString ?? "")"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
