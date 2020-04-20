//
//  File.swift
//  authJsonWebToken
//
//  Created by Israel Torres Alvarado  (Vendor) on 3/31/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import Moya

private let GET_ENCODING: ParameterEncoding = URLEncoding.queryString
private let POST_ENCODING: ParameterEncoding = JSONEncoding.prettyPrinted
private let POST_FORM: ParameterEncoding = URLEncoding.httpBody

struct APIModel {
    
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    let headers: [String : String]?
    
    init(baseURL: URL,
         path: String,
         method: Moya.Method,
         task: Moya.Task,
         headers: [String : String]?) {
        
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
    
}


struct GenericAPI: TargetType {
    
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(apiModel: APIModel) {
        self.baseURL = apiModel.baseURL
        self.path = apiModel.path
        self.method = apiModel.method
        self.task = apiModel.task
        self.headers = apiModel.headers
    }
}


let profileAPI = GenericAPI(apiModel: APIModel(baseURL: URL(string: "https://www.walmartmobile.com.mx/walmart-services/superamamobile/")!,
                                               path: "profile/private/getUserProfile", method: Moya.Method.get, task: Task.requestPlain, headers: nil))

let loginAPIDos = GenericAPI(apiModel: APIModel(baseURL: URL(string: "https://www.walmartmobile.com.mx/walmart-services/superamamobile/")!,
                                             path: "profile/login",
                                             method: Moya.Method.post,
                                             task: .requestParameters(parameters: ["email" : "israeltorres27@gmail.com", "password": "1234567890", "deviceId": ""], encoding: POST_ENCODING),
                                             headers: nil))



//enum ProfileAPI {
//    case getUserProfile
//}
//extension ProfileAPI: TargetType {
//
//    var baseURL: URL {
//         return URL(string: "https://www.walmartmobile.com.mx/walmart-services/superamamobile/")!
//    }
//
//    var path: String {
//        switch self {
//        case .getUserProfile:
//            return "profile/private/getUserProfile"
//        }
//    }
//
//    var method: Moya.Method {
//        switch self {
//        case .getUserProfile:
//            return .get
//        }
//    }
//
//    var sampleData: Data {
//        return Data()
//    }
//
//    var task: Task {
//        return .requestPlain
//    }
//
//    var headers: [String : String]? {
//         return ["Content-type": "application/json", "Accept": "application/json"]
//    }
//
//
//}
//
enum LoginAPI {
    case login(email: String, password: String, deviceId: String)
}
extension LoginAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://www.walmartmobile.com.mx/walmart-services/superamamobile/")!
    }

    var path: String {
        return "profile/login"
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .login(let email, let password, let deviceId):
            return .requestParameters(parameters: ["email" : email, "password": password, "deviceId": deviceId], encoding: POST_ENCODING)
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json", "Accept": "application/json"]
    }

}
