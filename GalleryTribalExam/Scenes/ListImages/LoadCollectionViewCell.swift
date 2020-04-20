//
//  LoadCollectionViewCell.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit

class LoadCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator.startAnimating()
        
    }
    
    override func prepareForReuse() {
        indicator.startAnimating()
    }

}
