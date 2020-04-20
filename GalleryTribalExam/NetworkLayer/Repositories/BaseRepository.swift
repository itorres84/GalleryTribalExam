//
//  BaseRepository.swift
//  IDAP
//
//  Created by Israel Torres Alvarado  (Vendor) on 1/11/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol Repository { }

public protocol InitializableRepository: Repository {
    init()
}

class BaseRepository: InitializableRepository {
    
    let provider: MultiMoyaProvider!
    
    required init() {
        provider = UnsplashService.current.service
    }
    
    /**
     API request for Ondemand
     
     - Parameter endpoint: Ondemand Moya endpoint.
     - Returns: An Observable with proper validation for APIResult
     */
    func observable<T: ResponseMappable>(endpoint: ImagesEnpoint) -> Observable<Result<[T]>> {
        return Observable.create { [weak self] observer in
            
            if let `self` = self {
                
                _ = self.provider.request(MultiTarget(endpoint))
                    .filterSuccessfulStatusCodes()
                    .map(to: [T].self)
                    .subscribe { event in
                        switch event {
                        case .success(let response):
                            observer.onNext(Result.success(response))
                            observer.onCompleted()
                        case .error(let error):
                            observer.onNext(Result.error(error))
                            observer.onCompleted()
                        }
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     API request for Ondemand
     
     - Parameter endpoint: Ondemand Moya endpoint.
     - Returns: An Observable with proper validation for APIResult
     */
    func observable<T: ResponseMappable>(endpoint: ImagesEnpoint) -> Observable<Result<T>> {
        return Observable.create { [weak self] observer in
            
            if let `self` = self {
                
                _ = self.provider.request(MultiTarget(endpoint))
                    .filterSuccessfulStatusCodes()
                    .map(to: T.self)
                    .subscribe { event in
                        switch event {
                        case .success(let response):
                            observer.onNext(Result.success(response))
                            observer.onCompleted()
                        case .error(let error):
                            observer.onNext(Result.error(error))
                            observer.onCompleted()
                        }
                }
            }
            
            return Disposables.create()
        }
    }
    
}

public enum Result<T> {
    case success(T)
    case error(Error)
}


