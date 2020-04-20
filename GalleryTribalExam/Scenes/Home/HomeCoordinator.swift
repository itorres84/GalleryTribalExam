//
//  HomeCoordinator.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum HomeTabBar: String {
    
    case home
    case favoritestab
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
}

protocol HomeCoordinator {
    func setRootViewController()
}


final class HomeCoordinatorImpl: BaseCoordinator<Void>, HomeCoordinator {
    
    private let window: UIWindow
    
    let homeViewController: HomeViewController
    let listImagesCoordinator: ListImagesCoordinator
    let favoritesCoordinator: FavoritesCoordinator
    
    init(window: UIWindow) {
        
        self.window = window
        homeViewController = HomeViewController()
        
        var controllers: [UIViewController] = []
        listImagesCoordinator = ListImagesCoordinator()
        _ = listImagesCoordinator.start()
        
        controllers.append(listImagesCoordinator.navigation)
        
        favoritesCoordinator = FavoritesCoordinator()
        _ = favoritesCoordinator.start()
        
        controllers.append(favoritesCoordinator.navigation)
        
        homeViewController.tabBar.isTranslucent = true
        homeViewController.viewControllers = controllers
        homeViewController.tabBar.tintColor = .systemBlue
        homeViewController.tabBar.unselectedItemTintColor = .gray
        homeViewController.tabBar.barTintColor = .white
        
        UINavigationBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.systemBlue]
        
    }
        
    func setRootViewController() {
        homeViewController.coordinator = self
        window.rootViewController = homeViewController
    }
    
    override func start() -> Observable<Void> {
        
        homeViewController.coordinator = self
        window.rootViewController = homeViewController
        return Observable.never()
    }

}

