//
//  FeedController.swift
//  InstagramClone
//
//  Created by A1398 on 02/04/2024.
//




import UIKit
protocol FeedControllerDelegate {
    func navigateToProfileController(user: User, backButtonHidden: Bool)
    func navigateCommentController(post:Post, correntUser: User)
    func navigateToLoginController()
}

final class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    var delegate: FeedControllerDelegate?
    private var viewModel = FeedViewModel()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureUI()
        fetchPosts()
        checkIfUserLikedPost()
        fetchCorrentUser()
    }
    
// MARK: - Actions
    
    @objc func handleRefresh() {
        viewModel.handleRefresh()
    }
    
    @objc func handleLogout() {
        viewModel.handleLogout()
    }
    
    // MARK: - Methods
    func fetchCorrentUser() {
        viewModel.fetchCorrentUser()
    }
    
    func fetchPosts() {
        viewModel.fetchPosts()
    }
    
    func checkIfUserLikedPost() {
        viewModel.checkIfUserLikedPost()
    }
    
    // MARK: - Helpers
    
    func setPost(post: Post) {
        viewModel.setPost(post: post)
    }
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: K.Cell.FeedCellIdentifier)
        if viewModel.getPost() == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleLogout))
        }
        navigationItem.title = "Feed"
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSizePosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.FeedCellIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = viewModel.getPost() {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: viewModel.getPosts(index: indexPath.row))
        }
        cell.configure()
        return cell
    }
}

// MARK: - FeedViewModelDelegate

extension FeedController: FeedViewModelDelegate {
    func successSignOut() {
        delegate?.navigateToLoginController()
    }
    
    func errorSignOut() {
        showMessage(widthTitle: "Error", message: "Error sign Out")
    }
    
    func successLikePost(cell: FeedCell, didLike post: Post) {
        print("XXX likeeee")
        cell.likeButton.setImage(UIImage(named:"like_selected"), for: .normal)
        cell.likeButton.tintColor = .red
        cell.viewModel?.post.likes = post.likes + 1
        cell.configure()
    }
    
    func successUnlikePost(cell: FeedCell, didLike post: Post) {
        cell.likeButton.setImage(UIImage(named:"like_unselected"), for: .normal)
        cell.likeButton.tintColor = .black
        cell.viewModel?.post.likes = post.likes - 1
        cell.configure()
    }
    
    func successWantsToShowProfileFor(user: User) {
        delegate?.navigateToProfileController(user: user, backButtonHidden: false)
    }
    
    func updateCV() {
        collectionView.reloadData()
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        viewModel.wantsToShowProfileFor(uid: uid)
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        guard let correntUser = viewModel.getCorrentUser() else {return}
        delegate?.navigateCommentController(post: post, correntUser: correntUser)
    }
  
    func cell(_ cell: FeedCell, didLike post: Post) {
        viewModel.didLike(cell: cell, didLike: post)
    }
}
