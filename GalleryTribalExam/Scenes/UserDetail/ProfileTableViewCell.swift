//
//  ProfileTableViewCell.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import Nuke

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnMessange: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblPhotos: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProfile.layer.cornerRadius = 75
        imageProfile.clipsToBounds = true
        
        btnMessange.layer.cornerRadius = 15
        btnMessange.clipsToBounds = true
        
        btnFollow.layer.cornerRadius = 15
        btnFollow.clipsToBounds = true
        
    }
    
    func configureCell(profile: UserView) {
        
        lblName.text = profile.name
        lblDescription.text = profile.bio
        lblPhotos.text = "\(profile.photos)"
        lblCollection.text = "\(profile.collections)"
        lblLikes.text = "\(profile.likes)"
        lblLocation.text = profile.location
        
        guard let url = profile.imageProfile else {
            return
        }
        
        Nuke.loadImage(with: url, into: imageProfile)
        
    }

}
