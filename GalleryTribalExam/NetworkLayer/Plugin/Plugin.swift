//
//  Provider.swift
//  authJsonWebToken
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/1/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation
import Moya

class AuthPlugin: PluginType {
  
  var preferencesHelper: PreferencesHelper
  
  init(preferencesHelper: PreferencesHelper) {
    self.preferencesHelper = preferencesHelper
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    
    guard !preferencesHelper.refreshToken.isEmpty else {
      return request
    }

    var request = request
    request.addValue(preferencesHelper.refreshToken, forHTTPHeaderField: "Authorization")
    
    dump(request)
    
    return request
  }
    
}
