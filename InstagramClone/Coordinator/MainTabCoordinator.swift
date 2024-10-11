//
//  MainTabCoordinator.swift
//  InstagramClone
//
//  Created by A1398 on 27/09/2024.
//

import UIKit

protocol MainTabCoordinatorDelegate {
    func showLoadingControllerFromMTC(child: Coordinator)
}

final class MainTabCoordinator: BaseCoordinator {
    
    var mainTab: UITabBarController?
    var delegate: MainTabCoordinatorDelegate?

    func start(user: User) {
        let searchCoordinator = SearchCoordinator(router: router)
        let feedCoordinator = FeedCoordinator(router: router)
        let notificationCoordinator = NotificationCoordinator(router: router)
        let profileCoordinator = ProfileCoordinator(router: router)
        let imageSelectorCoordinator = ImageSelectorCoordinator(router: router)
        
        feedCoordinator.delegate = self
        imageSelectorCoordinator.delegate = self

        let searchController = SearchController()
        let feedControler = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let imageSelectorController = ImageSelectorController(user: user)
        let notificationController = NotificationController()
        let profileController = ProfileController(user: user, backButtonHidden: true)

        searchController.delegate = searchCoordinator
        feedControler.delegate = feedCoordinator
        imageSelectorController.delegate = imageSelectorCoordinator
        notificationController.delegate = notificationCoordinator
        profileController.delegate = profileCoordinator

        childCoordinators.append(searchCoordinator)
        childCoordinators.append(feedCoordinator)
        childCoordinators.append(notificationCoordinator)
        childCoordinators.append(profileCoordinator)
        childCoordinators.append(imageSelectorCoordinator)

        mainTab = UITabBarController()
        mainTab?.view.backgroundColor = .white
        mainTab?.tabBar.backgroundColor = .white

        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: feedControler)

        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: searchController)

        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: imageSelectorController)

        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: notificationController)

        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)

        mainTab?.viewControllers = [feed, search, imageSelector, notifications, profile]
        mainTab?.tabBar.tintColor = .black
        router.push(viewController: mainTab!)
    }

    private func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        return navigationController
    }
}

extension MainTabCoordinator: FeedCoordinatorDelegate {
    func returnToSearchController(child: Coordinator) {}

    func showLoginController(child: Coordinator) {
        childCoordinators.removeAll()
        delegate?.showLoadingControllerFromMTC(child: self)
    }
}

extension MainTabCoordinator: ImageSelectorCoordinatorDelegate {
    func selectMainTabBar() {
        mainTab?.selectedIndex = 0

        guard let ImageNav = mainTab?.viewControllers?[2] as? UINavigationController else { return }
        guard let ImageSelector = ImageNav.viewControllers.first as? ImageSelectorController else { return }
        ImageSelector.runSelectImage = true
        guard let feedNav = mainTab?.viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
}
