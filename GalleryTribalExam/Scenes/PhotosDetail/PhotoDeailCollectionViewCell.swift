//
//  PhotoDeailCollectionViewCell.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import Nuke

protocol PhotoDeailCollectionViewCellDelegate: class {
    func tapButton(id: String)
}

class PhotoDeailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    
    weak var delegate: PhotoDeailCollectionViewCellDelegate?
    
    var idPhoto: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        btnFavorite.layer.cornerRadius = 15
        btnFavorite.clipsToBounds = true
        
        btnLikes.layer.cornerRadius = 15
        btnLikes.clipsToBounds = true
        
        lblLikes.layer.cornerRadius = 15
        lblLikes.clipsToBounds = true
        
    }
    
    func configureCell(dataView: ImageViewModel, isFavorite: Bool) {
        
        lblLikes.text = "\(dataView.likes)"
        
        btnFavorite.setImage(isFavorite ? UIImage(named: "hearton") : UIImage(named: "heartoff") , for: .normal)
        idPhoto = dataView.id
        
        guard let url = dataView.image else {
            return
        }
        
        Nuke.loadImage(with: url, into: imageView)
        
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        delegate?.tapButton(id: idPhoto)
    }
    
    
}
