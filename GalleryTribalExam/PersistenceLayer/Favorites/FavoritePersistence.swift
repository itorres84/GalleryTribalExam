//
//  FavoritePersistence.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol FavoritePersistence {
    func saveFavorite(favorite: FavoritePersistenceModel) -> Completable
    func getFavorites() -> Observable<[FavoritePersistenceModel]>
    func deleteFavorite(favorite: FavoritePersistenceModel) -> Completable
}

final class FavoritePersistenceImp: FavoritePersistence {
    
    let uiRealm: Realm
    
    init() {
        uiRealm = try! Realm()
    }
    
    func saveFavorite(favorite: FavoritePersistenceModel) -> Completable {
        
        do {
            
            try uiRealm.write { () -> Void in
                uiRealm.add(favorite)
            }
            
            return Completable.empty()
            
        } catch (let error) {
            return Completable.error(error)
        }
    }
    
    func getFavorites() -> Observable<[FavoritePersistenceModel]> {
        
        return Observable.create { observer in
            observer.onNext(FavoritePersistenceModel.getFavorites())
            observer.onCompleted()
            return Disposables.create()
        }
        
    }
    
    func deleteFavorite(favorite: FavoritePersistenceModel) -> Completable {
        
        do {
            
            try uiRealm.write { () -> Void in
        
                let predicate = NSPredicate(format: "id == %@", favorite.id)
                if let favoriteDelete = uiRealm.objects(FavoritePersistenceModel.self).filter(predicate).first {
                    uiRealm.delete(favoriteDelete)
                }
                
            }
            
            return Completable.empty()
            
        } catch (let error) {
            return Completable.error(error)
        }
        
    }
    
}
