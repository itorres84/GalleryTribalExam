//
//  ServiceEnvironment.swift
//  CoreNetwork
//
//  Created by Israel Torres Alvarado (Vendor) on 11/4/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation

public struct ServiceEnvironment {
    
    public let port: String
    public let HTTPProtocol: String
    public let host: String
    public let path: String
    
    public init(HTTPProtocol: String, port: String, host: String, path: String) {
        self.port = port
        self.HTTPProtocol = HTTPProtocol
        self.host = host
        self.path = path
    }
    
    public func baseURL() -> URL {
        return URL(staticString: HTTPProtocol + host + port + path)
    }

    public func hostURL() -> URL {
        return URL(staticString: HTTPProtocol + host)
    }
}
