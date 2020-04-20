//
//  FavoritePersistenceModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RealmSwift

class FavoritePersistenceModel: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var imageUserName: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var user: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
    
    /// Returns a list of [favorites]
    static func getFavorites() -> [FavoritePersistenceModel] {
        let uiRealm = try! Realm()
        let objects = uiRealm.objects(self.self)
    
        var array: [FavoritePersistenceModel] = []
        
        for result in objects.elements {
            let fav = FavoritePersistenceModel()
            fav.id = result.id
            fav.image = result.image
            fav.imageUserName = result.imageUserName
            fav.userName = result.userName
            fav.likes = result.likes
            fav.user = result.user
            array.append(fav)
        }

        return array
    }
    
}
