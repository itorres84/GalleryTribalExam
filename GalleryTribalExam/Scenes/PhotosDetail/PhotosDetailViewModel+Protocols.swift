//
//  PhotosDetailViewModel+Protocols.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotosDetailViewModelOutputs {
    var images: BehaviorRelay<[ImageViewModel]> { get }
    var userInfo: BehaviorRelay<(desription: String, image: URL?)> { get }
    var favorites: BehaviorRelay<[String]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishSubject<Error> { get }
}

protocol PhotosDetailViewModelInputs {
    var page: BehaviorRelay<Int> { get }
    var addFavorite: BehaviorRelay<String> { get }
}

protocol PhotosDetailViewModel {
    var outputs: PhotosDetailViewModelOutputs { get }
    var inputs: PhotosDetailViewModelInputs { get }
}
