import UIKit

//
//  FeedPostController.swift
//  InstagramClone
//
//  Created by A1398 on 03/10/2024.
//

protocol FeedPostControllerDelegate {
    func returnToPrevFromFeedPostController()
    func navigateToProfileController(user: User)
    func navigateCommentController(post: Post, correntUser: User)
}

final class FeedPostController: UIViewController {
    var viewModel: FeedPostViewModel
    var delegate: FeedPostControllerDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(post:Post) {
        viewModel = FeedPostViewModel(post: post)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.checkIfUserLikedPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configure()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        delegate?.returnToPrevFromFeedPostController()
    }
    
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.leftAnchor,
                                paddingTop: 12,
                                paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        view.addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView,
                               leftAnchor: profileImageView.rightAnchor,
                               paddingLeft: 8)
        
        view.addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        configureActionButtons()
        view.addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor,
                          left: view.leftAnchor,
                          paddingTop: -4,
                          paddingLeft: 8)
        view.addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor,
                            left: view.leftAnchor,
                          paddingTop: 8,
                          paddingLeft: 8)
        view.addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor,
                             left: view.leftAnchor,
                          paddingTop: 8,
                          paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func showUserProfile() {
        viewModel.wantsToShowProfileFor()
    }
    
    @objc func didTapComments() {
        viewModel.wantsToShowCommentsFor()
    }
    
    @objc func didTapLike() {
        viewModel.didLike()
    }
    
    // MARK: - Helpers
    
    func configure() {
         captionLabel.text = viewModel.caption
         postImageView.sd_setImage(with: viewModel.imageUrl)
         
         profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
         usernameButton.setTitle(viewModel.username, for: .normal)
         
         likesLabel.text = viewModel.likesLabelText
         likeButton.tintColor = viewModel.likeButtonTintColor
         likeButton.setImage(viewModel.likeButtonImage, for: .normal)
         
         postTimeLabel.text = viewModel.timestampString
    }
    
    func configureActionButtons() {
       let  stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
}

extension FeedPostController: FeedPostViewModelDelegate {
    func confUI() {
        configure()
    }
    
    func successUnlikePost() {
        likeButton.setImage(UIImage(named:"like_unselected"), for: .normal)
        likeButton.tintColor = .black
        configure()
    }
    
    func successLikePost() {
        likeButton.setImage(UIImage(named:"like_selected"), for: .normal)
        likeButton.tintColor = .red
        configure()
    }
    
    func successWantsToShowComment(correntUser: User) {
        delegate?.navigateCommentController(post: viewModel.post, correntUser: correntUser)
    }
    
    func successWantsToShowProfileFor(user: User) {
        delegate?.navigateToProfileController(user: user)
    }
}
