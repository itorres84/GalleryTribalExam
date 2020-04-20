//
//  UserDetailViewModel+Protocols.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDetailViewModelOutputs {
    var componets: BehaviorRelay<[UserDetailComponet]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishSubject<Error> { get }
}

protocol UserDetailViewModelInputs {
}

protocol UserDetailViewModel {
    var outputs: UserDetailViewModelOutputs { get }
    var inputs: UserDetailViewModelInputs { get }
}
