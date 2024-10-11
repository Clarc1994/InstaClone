//
//  SearchController.swift
//  InstagramClone
//
//  Created by A1398 on 02/04/2024.
//
import UIKit
protocol SearchControllerDelegate {
    func navigateToProfileController(user: User, backButtonHidden: Bool)
    func navigateToFeedPostController(post: Post)
}

final class SearchController: UIViewController {
    // MARK: - Propierties
    
    var delegate: SearchControllerDelegate?
    private var viewModel = SearchViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: K.Cell.postCellIdentifier)
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchPosts()
    }
    
    // MARK: - Method
    
    func fetchUsers() {
        viewModel.fetchUsers()
    }
    
    func fetchPosts() {
        viewModel.fetchPosts()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: K.Cell.userCellIdentifier)
        tableView.rowHeight = 64
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.isHidden = true
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - SearchViewModelDelegate

extension SearchController: SearchViewModelDelegate {
    func updateTV() {
        tableView.reloadData()
    }
    
    func updateCV() {
        collectionView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? viewModel.getSizeFilteredUsers() : viewModel.getSizeUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.userCellIdentifier, for: indexPath) as? UserCell
        let user = inSearchMode ? viewModel.getFilteredUsers(index: indexPath.row) : viewModel.getUser(index: indexPath.row)
        cell?.viewModel = UserCellViewModel(user: user)
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? viewModel.getFilteredUsers(index: indexPath.row) : viewModel.getUser(index: indexPath.row)
        delegate?.navigateToProfileController(user: user, backButtonHidden: false)
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterUser(searchText: searchController.searchBar.text?.lowercased())
    }
}

// MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSizePosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.postCellIdentifier, for: indexPath) as! ProfileCell
        cell.imageUrl = viewModel.getPostImageUrl(index: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToFeedPostController(post: viewModel.getPosts(index: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 ) / 3
        return CGSize(width: width, height: width)
    }
}
