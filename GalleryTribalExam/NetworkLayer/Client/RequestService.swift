//
//  RequestService.swift
//  CoreNetwork
//
//  Created by Israel Torres Alvarado  (Vendor) on 11/4/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    
    
    /// Designated request-making method.
    ///
    /// - Parameters:
    ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single response object.
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
}

public protocol RequestService {
    func request(request: TargetType) -> Single<Moya.Response>
}

public struct RequestServiceProvider: RequestService {
    
    private let provider: MoyaProvider<MultiTarget>
    
    public init(endpointClosure: @escaping MoyaProvider<MultiTarget>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                stubClosure: @escaping MoyaProvider<MultiTarget>.StubClosure = MoyaProvider.neverStub,
                manager: Manager = MoyaProvider<MultiTarget>.defaultAlamofireManager(),
                plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, output: NetworkLoggerPlugin.customReversedPrint),
                                         CachePlugin()],
                trackInflights: Bool = false) {
        
        self.provider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure,
                                                  stubClosure: stubClosure,
                                                  callbackQueue: nil,
                                                  manager: manager, plugins: plugins,
                                                  trackInflights: trackInflights)
    }
    
    public func request(request: TargetType) -> Single<Response> {
        return provider.rx.request(MultiTarget(request))
    }
    
}

struct Helper: PreferencesHelper {
    
    var token: String = ""
    var refreshToken: String = ""

}

class UnsplashService {
    
    static let current = UnsplashService()
    
    public lazy var service: MultiMoyaProvider = { [weak self] in
        
        let helper = Helper()
        let sessionPlugin = AuthPlugin(preferencesHelper: helper)
        return MultiMoyaProvider(preferencesHelper: helper, plugins: [sessionPlugin])
    
    }()
    
}
