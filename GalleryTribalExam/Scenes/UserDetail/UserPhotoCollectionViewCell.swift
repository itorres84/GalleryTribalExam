//
//  UserPhotoCollectionViewCell.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import Nuke

class UserPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    
    }
    
    func configureCell(_ url: URL?) {
        
        guard let photo = url else {
            return
        }
        Nuke.loadImage(with: photo, into: imageView)
    }
    

}
