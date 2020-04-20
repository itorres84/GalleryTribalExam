//
//  NetworkLoggerPlugin.swift
//  CoreNetwork
//
//  Created by Jesus Eduardo Santa Olalla Picazo  (Vendor) on 11/28/19.
//  Copyright © 2019 Walmart. All rights reserved.
//

import Foundation
import Moya

public extension NetworkLoggerPlugin {
    
    static func customReversedPrint(_ separator: String, terminator: String, items: Any...) {
        print("")
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
        print("")
    }
}
