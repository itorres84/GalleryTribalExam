//
//  MultiMoyaProvider.swift
//  authJsonWebToken
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/1/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol  PreferencesHelper {
    var token: String { get }
    var refreshToken: String { get }
}

final class MultiMoyaProvider: MoyaProvider<MultiTarget> {

    private let preferencesHelper: PreferencesHelper

    init(preferencesHelper: PreferencesHelper,
         endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         manager: Manager = MoyaProvider<MultiTarget>.defaultAlamofireManager(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        
        self.preferencesHelper = preferencesHelper
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
        
    }
    
    func request(_ token: MultiTarget) -> Single<Moya.Response> {
        let request = self.rx.request(token)
        return request
            .flatMap { response  in
                if response.statusCode == 401 {
                    return self.refreshSessionToken(oldCredentials: self.preferencesHelper).flatMap { (_) in
                        return self.request(token)
                    }
                } else {
                    return Single.just(response)
                }
        }
        
    }
    
    private func refreshSessionToken(oldCredentials: PreferencesHelper) -> Single<Moya.Response> {
        let model = APIModel(baseURL: URL(string: "")!, path: "", method: .get, task: .requestPlain, headers: nil)
        return self.request(MultiTarget(GenericAPI(apiModel: model)))
    }

}
