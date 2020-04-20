//
//  ListImagesViewModel+Protocols.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListImgagesViewModelOutputs {
    var images: BehaviorRelay<[ImageViewModel]> { get }
    var favorites: BehaviorRelay<[String]> { get } 
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishSubject<Error> { get }
}

protocol ListImagesViewModelInputs {
    var page: BehaviorRelay<Int> { get }
    var addFavorite: BehaviorRelay<String> { get }
}

protocol ListImagesViewModel {
    var outputs: ListImgagesViewModelOutputs { get }
    var inputs: ListImagesViewModelInputs { get }
}
