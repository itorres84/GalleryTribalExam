//
//  ResponseMappable.swift
//  CoreNetwork
//
//  Created by Israel Torres Alvarado  (Vendor) on 11/4/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol ResponseMappable {
    
    init(map: [String: Any])
    
}

public extension Dictionary where Key == String {
    
    func from<T>(_ key: String) -> T? {
        return self[key] as? T
    }
    
    func from<T: ResponseMappable>(_ field: String) -> T? {
        
        if let JSON: [String: Any] = from(field) {
            return T(map: JSON)
        }
        
        return nil
    }
    
    func from<T: ResponseMappable>(_ field: String) -> [T]? {
        
        if let JSON: [[String: Any]] = from(field) {
            return JSON.map { T(map: $0) }
        }
        
        return nil
    }
    
}

extension Response {
    
    func map<T: ResponseMappable>(to type: T.Type) throws -> T {
        
        guard let jsonDictionary = try mapJSON() as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        return T(map: jsonDictionary)
    }
    
    func map<T: ResponseMappable>(to type: T.Type, atKeyPath keyPath: String) throws -> T {
        
        guard let jsonDictionary = try mapJSON() as? [String: Any],
            let jsonObject: [String: Any] = jsonDictionary.from(keyPath) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return T(map: jsonObject)
    }
    
    func map<T: ResponseMappable>(to type: [T].Type) throws -> [T] {
       
        guard let jsonArray = try mapJSON() as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        
        return jsonArray.map { T(map: $0) }
    }
    
    func map<T: ResponseMappable>(to type: [T].Type, keyPath: String) throws -> [T] {
        
        guard let jsonDictionary = try mapJSON() as? [String: Any],
            let jsonArray: [[String: Any]] = jsonDictionary.from(keyPath) else {
                throw MoyaError.jsonMapping(self)
        }
        
        return jsonArray.map { T(map: $0) }
    }
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func map<T: ResponseMappable>(to type: T.Type, keyPath: String? = nil) -> Single<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background)).flatMap { response -> Single<T> in
            return Single.just(try response.map(to: type))
        }.observeOn(MainScheduler.instance)
    }
    
    func map<T: ResponseMappable>(to type: T.Type,atKeyPath keyPath: String) -> Single<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background)).flatMap { response -> Single<T> in
            return Single.just(try response.map(to: type, atKeyPath: keyPath))
        }.observeOn(MainScheduler.instance)
    }
    
    func map<T: ResponseMappable>(to type: [T].Type, keyPath: String) -> Single<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background)).flatMap { response -> Single<[T]> in
                return Single.just(try response.map(to: type, keyPath: keyPath))
        }.observeOn(MainScheduler.instance)
    }
    
    func map<T: ResponseMappable>(to type: [T].Type) -> Single<[T]> {
           return observeOn(ConcurrentDispatchQueueScheduler(qos: .background)).flatMap { response -> Single<[T]> in
                   return Single.just(try response.map(to: type))
           }.observeOn(MainScheduler.instance)
    }
    
}
