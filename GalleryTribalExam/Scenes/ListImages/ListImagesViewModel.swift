//
//  ListImagesViewModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ListImagesViewModelmpl: ListImagesViewModel, ListImgagesViewModelOutputs, ListImagesViewModelInputs {
    
    var outputs: ListImgagesViewModelOutputs { return self }
    var inputs: ListImagesViewModelInputs { return self }
    
    var images = BehaviorRelay<[ImageViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var error: PublishSubject<Error>
    var favorites = BehaviorRelay<[String]>(value: [])
    
    var page: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    var addFavorite: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    var pageControl: Int = 0
    
    var imagesService = BehaviorRelay<[ImageResponse]>(value: [])
    var imagesTotalContent: [ImageViewModel] = []
    
    let disposeBag = DisposeBag()
    
    private let imagesRepository: ImagesRepository
    private let favoritePercistence: FavoritePersistence
    
    let nc = NotificationCenter.default

    init(imagesRepository: ImagesRepository, favoritePercistence: FavoritePersistence) {
        self.imagesRepository = imagesRepository
        self.favoritePercistence = favoritePercistence
        self.error = PublishSubject()
        setupGetImages()
        bindingAddFavorites()
        nc.addObserver(self, selector: #selector(updateFav), name: Notification.Name("kUpdateFav"), object: nil)
    }
    
    deinit {
        nc.removeObserver("kUpdateFav")
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
            favorite.user = image.userid
            
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
    
    private func setupGetImages() {
    
        page.subscribe(onNext: { [weak self] (page) in
            
            guard let `self` = self, self.pageControl != page else { return }
            
            self.isLoading.accept(true)
            
            self.imagesRepository.getImages(page).subscribe(onNext: { (result) in
                
                switch result {
                    
                case .error(let error):
                    self.error.onNext(error)
                case .success(let images):
                    self.pageControl = page
                    self.imagesService.accept(images)
                    self.bindingFavorites()
                }
                
                self.isLoading.accept(false)
                
            }, onError: { (error) in
                
                self.error.onNext(error)
                self.isLoading.accept(false)
                
            }).disposed(by: self.disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        imagesService.subscribe(onNext: { [weak self] (imagesResponse) in
            
            guard let `self` = self else { return }
        
            let arrayImages = imagesResponse.map({ (imageResponse)  in
                return ImageViewModel(id: imageResponse.id, image: URL(string: imageResponse.urls.regular), likes: imageResponse.likes, userName: imageResponse.user.name, imageProfile: URL(string: imageResponse.user.profile_image.small), userid: imageResponse.user.username)
            })
            
            self.images.accept(arrayImages)
            _ = arrayImages.map({
                self.imagesTotalContent.append($0)
            })
                        
        }).disposed(by: disposeBag)
        
    }
    
    
}
