//
//  URL+Extensions.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation

extension URL {
    
    init(staticString string: String) {
        
        guard let url = URL(string: string) else {
            preconditionFailure("Invalid static URL string: \(string)")
        }

        self = url
    }
}
