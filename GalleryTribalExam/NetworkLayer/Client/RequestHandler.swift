//
//  RequestHandler.swift
//  CoreNetwork
//
//  Created by Israel Torres Alvarado  (Vendor) on 11/4/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    public func filterSuccessfulStatusCodes() -> Single<Element> {
        return flatMap { response -> Single<Element> in
            return Single.just(try response.filterSuccessfulStatusCodes())
        }
    }
}

public protocol RequestHandler {
    
    var provider: RequestService { get }

}

public extension RequestHandler {
    
    func performRequest<T: ResponseMappable>(_ endpoint: TargetType) -> Observable<T> {
        return Observable.create { observer in
            
            _ = self.provider.request(request: endpoint)
                .filterSuccessfulStatusCodes()
                    .map(to: T.self)
                    .subscribe { event in
                        
                        switch event {
                        case .success(let response):
                            
                            observer.onNext(response)
                            observer.onCompleted()
                            
                        case .error(let error):
                            observer.onError(error)
                            observer.onCompleted()
                        }
                }
            
            return Disposables.create()
        }
    }
    
    func performRequest<T: ResponseMappable>(_ endpoint: TargetType, keyPath: String) -> Observable<T> {
        return Observable.create { observer in
            
            _ = self.provider.request(request: endpoint)
                .filterSuccessfulStatusCodes()
                    .map(to: T.self, atKeyPath: keyPath)
                    .subscribe { event in
                        
                        switch event {
                        case .success(let response):
                            
                            observer.onNext(response)
                            observer.onCompleted()
                            
                        case .error(let error):
                            observer.onError(error)
                            observer.onCompleted()
                        }
                }
            
            return Disposables.create()
        }
    }
    
    func performRequest<T: ResponseMappable>(_ endpoint: TargetType, keyPath: String) -> Observable<[T]> {
        return Observable.create { observer in
            
            _ = self.provider.request(request: endpoint)
                .filterSuccessfulStatusCodes()
                    .map(to: [T].self, keyPath: keyPath)
                    .subscribe { event in
                        
                        switch event {
                        case .success(let response):
                            
                            observer.onNext(response)
                            observer.onCompleted()
                            
                        case .error(let error):
                            observer.onError(error)
                            observer.onCompleted()
                        }
                }
            
            return Disposables.create()
        }
    }
    
    func performRequestCustom<T: ResponseMappable>(_ endpoint: TargetType, keyPath: String) -> Observable<T> {
        return Observable.create { observer in
            
            _ = self.provider.request(request: endpoint)
                .filterSuccessfulStatusCodes()
                    .map(to: [T].self, keyPath: keyPath)
                    .subscribe { event in
                        
                        switch event {
                        case .success(let response):
                            
                            guard  let map = response.first else {
                                let errorTemp = NSError(domain: "Error parse Json", code: -10, userInfo: nil)
                                observer.onError(errorTemp)
                                observer.onCompleted()
                                return
                            }
                            
                            observer.onNext(map)
                            observer.onCompleted()
                            
                        case .error(let error):
                            observer.onError(error)
                            observer.onCompleted()
                        }
                }
            
            return Disposables.create()
        }
    }
    
}
