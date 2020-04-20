//
//  ListImagesViewController.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import RxSwift

class ListImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let bundle = Bundle(for: PhotoCollectionViewCell.self)
            collectionView.register(cellType: PhotoCollectionViewCell.self, bundle: bundle)
            collectionView.register(cellType: LoadCollectionViewCell.self, bundle: bundle)
            collectionView.collectionViewLayout = createLayout()
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    let viewModel: ListImagesViewModel
    let coordinator: ListImagesCoordinatorProtocol
    var page: Int = 1
    
    var images: [ImageViewModel] = [] {
        didSet{
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
        setupBindingImages()
        setUpBindingFavorites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setUpBindingFavorites() {
        
        viewModel.outputs.favorites.subscribe(onNext: { [weak self] (favorites) in
            
            guard let `self` = self else { return }
            self.favorites = favorites
            
        }).disposed(by: disposeBag)
        
    }
    
    func setupBindingImages() {
        
        viewModel.outputs.images.subscribe(onNext: { [weak self] (images) in
            
            guard let `self` = self else { return }
            
            _ = images.map({
                self.images.append($0)
            })
            
            }, onError: { (error) in
                
                dump(error)
                
        }).disposed(by: disposeBag)
        
    }
    
    init(viewModel: ListImagesViewModel, coordinator: ListImagesCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: ListImagesViewController.typeName , bundle: Bundle(for: type(of: self)))
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

extension ListImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count > 0 ? images.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let totalRecords = (page * 10) + 1
        let productIndex = indexPath.row + 1
        
        if productIndex == totalRecords {
            let loadCell = collectionView.dequeueReusableCell(with: LoadCollectionViewCell.self, for: indexPath)
            viewModel.inputs.page.accept(page + 1)
            return loadCell
        }
               
        let cell = collectionView.dequeueReusableCell(with: PhotoCollectionViewCell.self, for: indexPath)
        let image = images[indexPath.row]
        cell.configureCell(image: image.image, nameUser: image.userName, likes: image.likes, imageProfileSer: image.imageProfile, favorites.contains(image.id), id: image.id)
        cell.delegate = self
    
        return cell
    }
    
}

extension ListImagesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        coordinator.goToUserDetail(user: image.userid)
    }
    
}

extension ListImagesViewController: PhotoCollectionViewCellDelegate {
    
    func tapButton(id: String) {
        viewModel.inputs.addFavorite.accept(id)
    }
    
}
