//
//  ImagesEnpoint.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import Moya

private let GET_ENCODING: ParameterEncoding = URLEncoding.queryString
private let POST_ENCODING: ParameterEncoding = JSONEncoding.prettyPrinted
private let POST_FORM: ParameterEncoding = URLEncoding.httpBody

let client_id = "nEUD7G08Asd_KKxd4VoJhhT-KyIoM6w2Htx0WqR3ZxA"


enum ImagesEnpoint {
    case getImages(_ page: Int)
    case getUser(_ user: String)
    case getUserPhotos(_ user: String, _ page: Int)
}

extension ImagesEnpoint: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/")!
    }
    
    var path: String {
        switch self {
        case .getImages:
            return "photos"
        case .getUser(let user):
            return "users/\(user)"
        case .getUserPhotos(let user, _):
            return "users/\(user)/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getImages, .getUser, .getUserPhotos:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getImages(let page):
            return .requestParameters(parameters:
                           ["client_id": client_id,
                            "page": page,
                            "per_page": 10
                           ], encoding: GET_ENCODING)
        case .getUser(_):
            return .requestParameters(parameters:
            ["client_id": client_id,], encoding: GET_ENCODING)
        
        case .getUserPhotos(_ , let page):
            return .requestParameters(parameters:
            ["client_id": client_id,
             "page": page,
             "per_page": 10
            ], encoding: GET_ENCODING)
        
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
}

