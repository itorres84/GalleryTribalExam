//
//  FavoritesViewModel+Protocols.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoritesViewModelOutputs {
    var images: BehaviorRelay<[ImageViewModel]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishSubject<Error> { get }
}

protocol FavoritesViewModelInputs {
    var deleteFavorite: BehaviorRelay<String> { get }
}

protocol FavoritesViewModel {
    var outputs: FavoritesViewModelOutputs { get }
    var inputs: FavoritesViewModelInputs { get }
}
