
//
//  UserDeatil.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation

struct UserView {
    
    var imageProfile: URL?
    var name: String
    var bio: String
    var photos: Int
    var collections: Int
    var likes: Int
    var location: String
    
    init(imageProfile: URL? = nil,
         name: String = "",
         bio: String = "",
         photos: Int = 0,
         collections: Int = 0,
         likes: Int = 0,
         location: String = "") {
        
        self.imageProfile = imageProfile
        self.name = name
        self.bio = bio
        self.photos = photos
        self.collections = collections
        self.likes = likes
        self.location = location
        
    }
    
}

enum UserDetailComponet {
    
    case user(_ user: UserView)
    case photos(_ images: [ImageViewModel])
    
}
