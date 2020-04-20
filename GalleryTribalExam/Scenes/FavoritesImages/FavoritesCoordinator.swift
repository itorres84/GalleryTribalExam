//
//  FavoritesCoordinator.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol FavoritesCoordinatorProtocol: class {
    func goToUserDetail(user: String)
}

final class FavoritesCoordinator: BaseCoordinator<Void>, FavoritesCoordinatorProtocol {
   
    let navigation: UINavigationController
    
    override init() {
        self.navigation = UINavigationController()
    }
    
    override func start() -> Observable<Void> {
        let viewController = FavoritesViewController(viewModel: FavoritesViewModelImp(favoritePercistence: FavoritePersistenceImp()), coordinator: self)
        viewController.tabBarItem = UITabBarItem(title: "Favoritos", image: HomeTabBar.favoritestab.image, tag: 1)
        viewController.title = "Favoritos"
        viewController.navigationController?.navigationBar.tintColor = .systemBlue
        navigation.viewControllers = [viewController]
        return Observable.never()
    }
    
    func goToUserDetail(user: String) {
        
        let coordinator = CoordinatorUserDetail(navigation: navigation, user: user)
        _ = coordinator.start()
        
    }
    
}
