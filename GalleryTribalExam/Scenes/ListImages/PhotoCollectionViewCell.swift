//
//  PhotoCollectionViewCell.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import RxSwift
import Nuke

protocol PhotoCollectionViewCellDelegate: class {
    func tapButton(id: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnlikes: UIButton!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    let disponseBag = DisposeBag()
    var id: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        btnlikes.layer.cornerRadius = 15
        btnFavorites.layer.cornerRadius = 15
        lblLikes.layer.cornerRadius = 10
        lblLikes.clipsToBounds = true
        
        imageProfile.layer.cornerRadius = 15
        imageProfile.clipsToBounds = true
        
    }
    
    func configureCell(image: URL?, nameUser: String, likes: Int, imageProfileSer: URL?, _ isFavorite: Bool = false, id: String = "") {
    
        self.id = id
        
        lblName.text = nameUser
        lblLikes.text = "\(likes)"
        
        guard let url = image else {
            return
        }
        
        btnFavorites.setImage(isFavorite ? UIImage(named: "hearton") : UIImage(named: "heartoff") , for: .normal)
        Nuke.loadImage(with: url, into: imageView)
    
        guard let urlProfile = imageProfileSer else {
            return
        }
        
        Nuke.loadImage(with: urlProfile, into: imageProfile)
        
    }
    
    @IBAction func tapFsvorites(_ sender: UIButton) {
        
        self.delegate?.tapButton(id: self.id)
        
    }

}
