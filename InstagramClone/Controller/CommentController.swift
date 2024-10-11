//
//  CommentController.swift
//  InstagramClone
//
//  Created by A1398 on 22/08/2024.
//

import UIKit

protocol CommentControllerDelegate {
    func navigateToProfileController(user: User)
    func returnToPrevController()
}

final class CommentController: UICollectionViewController {
    // MARK: - Properties
    var delegate: CommentControllerDelegate?
    private var viewModel: CommentViewModel
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    init(post: Post, correntUser: User) {
        viewModel = CommentViewModel(post: post, correntUser: correntUser)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configreCollectionView()
        fetchComments()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Method
    
    func fetchComments() {
        viewModel.fetchComments()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        delegate?.returnToPrevController()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func configreCollectionView() {
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: K.Cell.commentCellIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

extension CommentController: CommentViewModelDelegate {
    func succesUploadCommentAndNotification(inputView: CommentInputAccesoryView) {
        showLoader(false)
        inputView.clearCommentTextView()
    }
    
    func showProfile(user: User) {
        let controller = ProfileController(user: user, backButtonHidden: false)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateCV() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSizeComments()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.commentCellIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentCellViewModel(comment: viewModel.getComment(index: indexPath.row))
        return cell
    }
}

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.fetchUser(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellviewModel = CommentCellViewModel(comment: viewModel.getComment(index: indexPath.row))
        let height = cellviewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - CommentInputAccesoryViewDelegate

extension CommentController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        let correntUser = viewModel.getCorrentUser()
        showLoader(true)
        viewModel.uploadCommentAndNotification(inputView: inputView, comment: comment, correntUser: correntUser)
    }
}
