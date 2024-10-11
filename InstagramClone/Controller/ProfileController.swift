//
//  ProfileController.swift
//  InstagramClone
//
//  Created by A1398 on 02/04/2024.
//

import UIKit

protocol ProfileControllerDelegate {
    func navigateToFeedPostController(post: Post)
    func returnToPrevController()
}

enum ListType {
    case grid
    case list
    case followers
}

final class ProfileController: UICollectionViewController {
    // MARK: - Properties
    var delegate: ProfileControllerDelegate?
    private var viewModel: ProfileViewModel
    var backButtonHidden: Bool
    var listType: ListType
    
    // MARK: - Lifecycle
    
    init (user: User, backButtonHidden: Bool) {
        viewModel = ProfileViewModel(user: user)
        self.backButtonHidden = backButtonHidden
        viewModel.fetchCurrentUser()
        viewModel.fetchFollowersUsers()
        listType = .grid
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.configureCollectionView()
        self.configureUI()
        self.checkIfUserIsFollowed()
        self.fetchUserStats()
        self.fetchPosts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    // MARK: - Functions
    
    func checkIfUserIsFollowed() {
        viewModel.checkIfUserIsFollowed()
    }
    
    func fetchUserStats() {
        viewModel.fetchUserStats()
    }
    
    func fetchPosts() {
        viewModel.fetchPosts()
    }
    
    // MARK: - Helpers
    
    @objc func back(sender: UIBarButtonItem) {
        delegate?.returnToPrevController()
    }
    
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        if backButtonHidden == false {
            let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }
    
    func configureCollectionView() {
        navigationItem.title = viewModel.getUsername()
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: K.Cell.postCellProfileIdentifier)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: K.Cell.cellProfileIdentifier)
        
        collectionView.register(UserCellProfile.self, forCellWithReuseIdentifier: K.Cell.userCellProfileIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Cell.headerIdentifier)
    }
}

extension ProfileController: ProfileViewModelDelegate {
    func errorUnfolow(error: Error) {
        showMessage(widthTitle: "Error", message: "The surgery could not be performed. Try again later.")
    }
    
    func errorFollow(error: Error) {
        showMessage(widthTitle: "Error", message: "The surgery could not be performed. Try again later.")
    }
    
    func showEditProfile() {
        print("DEBUG: Show edit profile here")
    }
    
    func updateCV() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listType == .followers {
            return viewModel.getSizeFollowersUser()
        } else {
            return viewModel.getSizePosts()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listType == .grid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.cellProfileIdentifier, for: indexPath) as! ProfileCell
            cell.imageUrl = viewModel.getImageURLPostCell(index: indexPath.row)
            return cell
        } else if listType == .list {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.postCellProfileIdentifier, for: indexPath) as! PostCell
            cell.viewModel = PostCellViewModel(statPost: viewModel.getStatPost(index: indexPath.row))
            cell.configureUI()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.userCellProfileIdentifier, for: indexPath) as! UserCellProfile
            cell.viewModel = UserCellViewModel(user: viewModel.getFollowersUser(index: indexPath.row))
          return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.Cell.headerIdentifier, for: indexPath) as? ProfileHeader
        header?.delegate = self
        header?.viewModel = ProfileHeaderViewModel(user: viewModel.getUser())
        return header!
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listType != .followers {
            delegate?.navigateToFeedPostController(post: viewModel.getRecordInPosts(index: indexPath.row))
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1
     }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 1
     }
     
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          if listType == .grid {
              let width = (view.frame.width - 2 ) / 3
              return CGSize(width: width, height: width)
          } else if listType == .list {
              let width = view.frame.width
              return CGSize(width: width, height: 50)
          } else {
              let width = view.frame.width
              return CGSize(width: width, height: 64)
          }
      }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         return CGSize(width: view.frame.width, height: 240)
     }
}

// MARK: - ProfileController: ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func gridButtonTapped() {
        listType = .grid
        collectionView.reloadData()
    }
    
    func listButtonTapped() {
        listType = .list
        collectionView.reloadData()
    }
    
    func personButtonTapped() {
        listType = .followers
        collectionView.reloadData()
    }
    
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        viewModel.buttonHeaderAction()
    }
}
