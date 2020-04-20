//
//  imagesRepository.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift

protocol ImagesRepository {
    func getImages(_ page: Int) -> Observable<Result<[ImageResponse]>>
    func getUser(_ user: String) -> Observable<Result<User>>
    func getUserPhotos(_ user: String, _ page: Int) -> Observable<Result<[ImageResponse]>>
}

final class ImagesRepositoryImp: BaseRepository, ImagesRepository {
    
    func getImages(_ page: Int) -> Observable<Result<[ImageResponse]>> {
        return observable(endpoint: ImagesEnpoint.getImages(page))
    }
    
    func getUser(_ user: String) -> Observable<Result<User>> {
        return observable(endpoint: ImagesEnpoint.getUser(user))
    }
    
    func getUserPhotos(_ user: String, _ page: Int) -> Observable<Result<[ImageResponse]>> {
        return observable(endpoint: ImagesEnpoint.getUserPhotos(user, page))
    }
    
}


