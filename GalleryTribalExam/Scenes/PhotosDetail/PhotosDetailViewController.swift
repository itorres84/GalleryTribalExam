//
//  PhotosDetailViewController.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/20/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class PhotosDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            let bundle = Bundle(for: PhotoDeailCollectionViewCell.self)
            collectionView.register(cellType: PhotoDeailCollectionViewCell.self, bundle: bundle)
            collectionView.register(cellType: LoadCollectionViewCell.self, bundle: bundle)
            collectionView.collectionViewLayout = createLayout()
        }
    }
    
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
        }
    }
    
    let viewModel: PhotosDetailViewModel
    
    private let disposeBag = DisposeBag()
    
    var page: Int = 1
    
    var images: [ImageViewModel] = [] {
        didSet {
            if images.count > 10 {
                page = images.count / 10
            }
            collectionView.reloadData()
        }
    }
    
    var favorites: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingImages()
        setUpBindingFavorites()
    }
    
    private func bindingImages() {
        
        viewModel.outputs.images.subscribe(onNext: { [weak self] (images) in
            
            guard let `self` = self else { return }
            
            _ = images.map({
                self.images.append($0)
            })
        
        }).disposed(by: disposeBag)
        
        viewModel.outputs.userInfo.subscribe(onNext: { [weak self] (userInfo) in
                    
            guard let self = self else { return }
            
            self.lblDescription.text = userInfo.desription
            guard let url = userInfo.image else { return }
            Nuke.loadImage(with: url, into: self.imageView)
            
        }).disposed(by: disposeBag)
        
    }
    
    func setUpBindingFavorites() {
        
        viewModel.outputs.favorites.subscribe(onNext: { [weak self] (favorites) in
            
            guard let `self` = self else { return }
            self.favorites = favorites
            
        }).disposed(by: disposeBag)
        
    }
    
    init(viewModel: PhotosDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: PhotosDetailViewController.typeName , bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayout() -> UICollectionViewLayout {
         
         let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
             
             let topItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
             
             topItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
             
             let leadingBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
             leadingBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
             
             let leadingBottomGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)), subitem: leadingBottomItem, count: 2)
             
             let trailingBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
             trailingBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
             
             let trailingBottomGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)), subitem: trailingBottomItem, count: 3)
             
             let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.7)), subitems: [leadingBottomGroup, trailingBottomGroup])
             
             let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [topItem, bottomGroup])
             
             let section = NSCollectionLayoutSection(group: nestedGroup)
             section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
             
             return section
         }
         
         return layout
     }
    
}

extension PhotosDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count > 0 ? images.count >= 10 ? images.count + 1 : images.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let totalRecords = (page * 10) + 1
        let productIndex = indexPath.row + 1
        
        if productIndex == totalRecords {
            let loadCell = collectionView.dequeueReusableCell(with: LoadCollectionViewCell.self, for: indexPath)
            viewModel.inputs.page.accept(page + 1)
            return loadCell
        }
        
        let cell = collectionView.dequeueReusableCell(with: PhotoDeailCollectionViewCell.self, for: indexPath)
        cell.configureCell(dataView: images[indexPath.row], isFavorite: favorites.contains(images[indexPath.row].id))
        cell.delegate = self
        return cell
        
    }
    
}

extension PhotosDetailViewController: PhotoDeailCollectionViewCellDelegate {
    
    func tapButton(id: String) {
        viewModel.inputs.addFavorite.accept(id)
    }
    
}
