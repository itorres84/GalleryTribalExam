//
//  ImageViewModel.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation

struct ImageViewModel {
    
    var id: String
    var image: URL?
    var likes: Int
    var userName: String
    var imageProfile: URL?
    var userid: String

    init(id: String, image: URL?, likes: Int, userName: String, imageProfile: URL?, userid: String = "") {
        self.id = id
        self.image = image
        self.likes = likes
        self.userName = userName
        self.imageProfile = imageProfile
        self.userid = userid
    }
    
    
}
