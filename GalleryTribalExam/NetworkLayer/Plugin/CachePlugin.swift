//
//  CachePlugin.swift
//  CoreNetwork
//
//  Created by Jesus Eduardo Santa Olalla Picazo  (Vendor) on 11/4/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation
import Moya

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

public struct CachePlugin: PluginType {
    
    public init() {}
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        
        return request
    }
    
}
