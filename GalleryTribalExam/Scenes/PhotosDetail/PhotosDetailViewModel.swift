//
//  PhotosDetailViewModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class PhotosDetailViewModelImp: PhotosDetailViewModel, PhotosDetailViewModelOutputs, PhotosDetailViewModelInputs {
    
    var outputs: PhotosDetailViewModelOutputs { return self }
    var inputs: PhotosDetailViewModelInputs { return self }
    
    var images = BehaviorRelay<[ImageViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var favorites = BehaviorRelay<[String]>(value: [])
    var error: PublishSubject<Error>
    var userInfo = BehaviorRelay<(desription: String, image: URL?)>(value: ("", nil))
    
    var page: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    var addFavorite = BehaviorRelay<String>(value: "")
    
    private var id: String
    private var imagesRepository: ImagesRepository
    private var favoritePercistence: FavoritePersistence
    private var disposeBag = DisposeBag()
    private var imagesService = BehaviorRelay<[ImageResponse]>(value: [])
    private var imagesTotalContent: [ImageViewModel] = []
    private let nc = NotificationCenter.default
    
    init(id: String, imagesRepository: ImagesRepository, favoritePercistence: FavoritePersistence) {
        
        self.id = id
        self.imagesRepository = imagesRepository
        self.favoritePercistence = favoritePercistence
        error = PublishSubject()
        
        page.subscribe(onNext: { [weak self] (page) in
            
            guard let `self` = self else { return }
            
            self.isLoading.accept(true)
            
            self.imagesRepository.getUserPhotos(self.id, page).subscribe(onNext: { (result) in
                
                switch result {
                    
                case .error(let error):
                    self.error.onNext(error)
                case .success(let images):
                    dump(images)
                    //self.pageControl = page
                    self.imagesService.accept(images)
                }
                
                
            }, onError: { (error) in
                
                debugPrint(error.localizedDescription)
                
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        imagesService.subscribe(onNext: { [weak self] (imagesResponse) in
            
            guard let `self` = self else { return }
            
            if let infoUser = imagesResponse.first {
                self.userInfo.accept((infoUser.user.bio, image: URL(string: infoUser.user.profile_image.medium)))
            }
            
            let arrayImages = imagesResponse.map({ (imageResponse)  in
                return ImageViewModel(id: imageResponse.id, image: URL(string: imageResponse.urls.regular), likes: imageResponse.likes, userName: imageResponse.user.name, imageProfile: URL(string: imageResponse.user.profile_image.small), userid: imageResponse.user.username)
            })
            
            self.images.accept(arrayImages)
            self.bindingFavorites()
            _ = arrayImages.map({
                self.imagesTotalContent.append($0)
            })
            
        }).disposed(by: disposeBag)
        
        bindingAddFavorites()
        nc.addObserver(self, selector: #selector(updateFav), name: Notification.Name("kUpdateFav"), object: nil)
        
    }
    
    @objc private func updateFav() {
        bindingFavorites()
    }
    
    private func bindingFavorites() {
        
        favoritePercistence.getFavorites().subscribe(onNext: { [weak self] (favorites) in
            
            guard let `self` = self else { return }
            self.favorites.accept(favorites.map({ $0.id }))
            
        }).disposed(by: disposeBag)
        
    }
    
    private func bindingAddFavorites() {
        
        addFavorite.subscribe(onNext: { [weak self] (id) in
            
            guard let `self` = self,  let image = self.imagesTotalContent.filter({ $0.id.elementsEqual(id) }).first else { return }
            
            let favorite = FavoritePersistenceModel()
            favorite.id = image.id
            favorite.image = image.image?.absoluteString ?? ""
            favorite.userName = image.userName
            favorite.imageUserName = image.imageProfile?.absoluteString ?? ""
            favorite.likes = image.likes
            
            
            if self.favorites.value.contains(id) {
                
                self.favoritePercistence.deleteFavorite(favorite: favorite).subscribe(onCompleted: {
                    self.nc.post(name: Notification.Name("kUpdateFav"), object: nil)
                }) { (error) in
                    print(error.localizedDescription)
                }.disposed(by: self.disposeBag)
                
            } else {
                
                self.favoritePercistence.saveFavorite(favorite: favorite).subscribe(onCompleted: {
                    self.nc.post(name: Notification.Name("kUpdateFav"), object: nil)
                }) { (error) in
                    print(error.localizedDescription)
                }.disposed(by: self.disposeBag)
                
            }
            
        }).disposed(by: disposeBag)
        
    }

    
}
