//
//  FavoritesViewModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class FavoritesViewModelImp: FavoritesViewModel, FavoritesViewModelOutputs, FavoritesViewModelInputs {
    
    var outputs: FavoritesViewModelOutputs { return self }
    var inputs: FavoritesViewModelInputs { return self }
    
    var images = BehaviorRelay<[ImageViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var error: PublishSubject<Error>
    
    var deleteFavorite = BehaviorRelay<String>(value: "")
    
    private let favoritePercistence: FavoritePersistence
    private let disposeBag = DisposeBag()
    let nc = NotificationCenter.default
    
    init(favoritePercistence: FavoritePersistence) {
        self.favoritePercistence = favoritePercistence
        error = PublishSubject()
        setUpBindingFavorites()
        bindingDeleteFavorite()
        nc.addObserver(self, selector: #selector(updateFav), name: Notification.Name("kUpdateFav"), object: nil)
    }
    
    deinit {
        nc.removeObserver("kUpdateFav")
    }
    
    @objc private func updateFav() {
        setUpBindingFavorites()
    }
    
    private func setUpBindingFavorites() {
        
        self.favoritePercistence.getFavorites().subscribe(onNext: { [weak self] (favorites) in
            
            guard let `self` = self else { return }
            
            self.images.accept(favorites.map({ ImageViewModel(id: $0.id, image: URL(string: $0.image), likes: $0.likes, userName: $0.userName, imageProfile: URL(string: $0.imageUserName), userid: $0.user) }))
            
        }).disposed(by: disposeBag)
                
    }
    
    private func bindingDeleteFavorite() {
        
        deleteFavorite.subscribe(onNext: { [weak self] (id) in
            
            guard let `self` = self else { return }
            
            if let image = self.images.value.filter({ $0.id.elementsEqual(id) }).first {
                
                let fav = FavoritePersistenceModel()
                fav.id = image.id
                self.favoritePercistence.deleteFavorite(favorite: fav).subscribe(onCompleted: {
                
                    self.nc.post(name: Notification.Name("kUpdateFav"), object: nil)
                    
                }) { (error) in
                    
                    print(error.localizedDescription)
                    
                }.disposed(by: self.disposeBag)
            
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}
