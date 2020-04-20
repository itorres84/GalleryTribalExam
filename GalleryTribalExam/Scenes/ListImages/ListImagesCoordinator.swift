//
//  ListImagesCoordinator.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol ListImagesCoordinatorProtocol {
    func goToUserDetail(user: String)
}


final class ListImagesCoordinator: BaseCoordinator<Void>, ListImagesCoordinatorProtocol {
   
    let navigation: UINavigationController
       
    override init() {
        self.navigation = UINavigationController()
    }
    
    override func start() -> Observable<Void> {
        let viewController = ListImagesViewController(viewModel: ListImagesViewModelmpl(imagesRepository: ImagesRepositoryImp(), favoritePercistence: FavoritePersistenceImp()), coordinator: self)
        viewController.tabBarItem = UITabBarItem(title: "Home", image: HomeTabBar.home.image, tag: 0)
        viewController.title = "Photos"
        viewController.navigationController?.navigationBar.tintColor = .systemBlue
        navigation.viewControllers = [viewController]
        return Observable.never()
    }
    
    func goToUserDetail(user: String) {
            
        let coordinator = CoordinatorUserDetail(navigation: navigation, user: user)
        _ = coordinator.start()
        
    }
}
