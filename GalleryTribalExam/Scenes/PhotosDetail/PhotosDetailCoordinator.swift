//
//  PhotosDetailCoordinator.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import UIKit
import RxSwift


final class PhotosDetailCoordinator: BaseCoordinator<Void> {
    
    let navigation: UINavigationController
    let id: String
    
    init(navigation: UINavigationController, id: String) {
        self.id = id
        self.navigation = navigation
    }
    
    override func start() -> Observable<Void> {

        let vc = PhotosDetailViewController(viewModel: PhotosDetailViewModelImp(id: id, imagesRepository: ImagesRepositoryImp(), favoritePercistence: FavoritePersistenceImp()))
        
        navigation.pushViewController(vc, animated: true)
        
        return Observable.never()
    }
    
    
}
