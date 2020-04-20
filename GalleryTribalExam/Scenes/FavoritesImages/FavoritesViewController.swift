//
//  FavoritesViewController.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/17/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let bundle = Bundle(for: PhotoCollectionViewCell.self)
            collectionView.register(cellType: PhotoCollectionViewCell.self, bundle: bundle)
            collectionView.collectionViewLayout = createLayout()
        }
    }
    
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
        }
    }
    
    var favorites: [ImageViewModel] = [] {
        didSet {
            
            emptyView.isHidden = !favorites.isEmpty
            collectionView.reloadData()
            
        }
    }
    
    
    let viewModel: FavoritesViewModel
    let coordinator: FavoritesCoordinatorProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingFavorites()
    }
    
    private func bindingFavorites() {
        
        viewModel.outputs.images.subscribe(onNext: { [weak self] (images) in
                    
            guard let `self` = self else { return }
            self.favorites = images
            
        }).disposed(by: disposeBag)
    
    }
    
    init(viewModel: FavoritesViewModel, coordinator: FavoritesCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: FavoritesViewController.typeName , bundle: Bundle(for: type(of: self)))
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

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PhotoCollectionViewCell.self, for: indexPath)
        let image = favorites[indexPath.row]
        cell.configureCell(image: image.image, nameUser: image.userName, likes: image.likes, imageProfileSer: image.imageProfile, true, id: image.id)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fav = favorites[indexPath.row]
        coordinator.goToUserDetail(user: fav.userid)
    }

}

extension FavoritesViewController: PhotoCollectionViewCellDelegate {
    
    func tapButton(id: String) {
        viewModel.inputs.deleteFavorite.accept(id)
    }

}
