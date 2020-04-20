//
//  CoordinatorUserDetail.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol CoordinatorUserDetailProtocol {
    func goToPhotosDetail()
}

final class CoordinatorUserDetail: BaseCoordinator<Void>, CoordinatorUserDetailProtocol {
   
    let navigation: UINavigationController
    let user: String
      
    init(navigation: UINavigationController, user: String) {
        self.navigation = navigation
        self.user = user
    }
    
    override func start() -> Observable<Void> {
        
        let viewController = UserDetailViewController(viewModel: UserDetailtViewModelImp(imagesRepository: ImagesRepositoryImp(), id: user), coordinator: self)
        
        viewController.navigationController?.navigationBar.tintColor = .systemBlue
        print("user: \(user)")
        navigation.pushViewController(viewController, animated: true)
        return Observable.never()
        
    }
    
    func goToPhotosDetail() {
           
        let coordinator = PhotosDetailCoordinator(navigation: navigation, id: user)
        _ = coordinator.start()
        
        
    }
}
