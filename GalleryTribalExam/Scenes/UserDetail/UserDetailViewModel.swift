//
//  UserDetailViewModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


final class UserDetailtViewModelImp: UserDetailViewModel, UserDetailViewModelOutputs, UserDetailViewModelInputs {
    
    var outputs: UserDetailViewModelOutputs { return self }
    var inputs: UserDetailViewModelInputs { return self }
   
    var isLoading = BehaviorRelay<Bool>(value: false)
    var error: PublishSubject<Error>
    var componets = BehaviorRelay<[UserDetailComponet]>(value: [])
    
    private let imagesRepository: ImagesRepository
    
    private let disposeBag = DisposeBag()
    
    init(imagesRepository: ImagesRepository, id: String) {
        self.imagesRepository = imagesRepository
        error = PublishSubject()
        getUserAndBindingResponse(id: id)
    }
    
    func getUserAndBindingResponse(id: String) {
        
        imagesRepository.getUser(id).subscribe(onNext: { [weak self] (result) in
        
            guard let `self` = self else { return }
            
            switch result {
            case .success(let user):
                
                let componetUser = UserDetailComponet.user(UserView(imageProfile: URL(string: user.profile_image.large), name: user.name, bio: user.bio, photos: user.total_photos, collections: user.total_collections, likes: user.total_likes, location: user.location))
                
                self.imagesRepository.getUserPhotos(id, 1).subscribe(onNext: { (result) in
                    
                    switch result {
                    case .success(let images):
                        
                        let componetPhotos = UserDetailComponet.photos(images.map({ ImageViewModel(id: $0.id, image: URL(string: $0.urls.regular), likes: $0.likes, userName: $0.user.name, imageProfile: URL(string: $0.user.profile_image.large), userid: $0.user.username) }))
                        
                        self.componets.accept([componetUser, componetPhotos])
                    case .error(let error):
                        self.componets.accept([componetUser])
                        print(error.localizedDescription)
                    }
                    
                }).disposed(by: self.disposeBag)
                
                
            case .error(let err):
                print(err.localizedDescription)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}
