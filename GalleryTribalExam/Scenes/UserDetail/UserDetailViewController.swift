//
//  User UserDetailViewController.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/19/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import UIKit
import RxSwift

class UserDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            let bundle = Bundle(for: ProfileTableViewCell.self)
            tableView.register(cellType: ProfileTableViewCell.self , bundle: bundle)
            tableView.register(cellType: PhotosTableViewCell.self, bundle: bundle)
        }
    }
        
    var components: [UserDetailComponet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let viewModel: UserDetailViewModel
    let coordinator: CoordinatorUserDetailProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindigComponents()

    }

    func bindigComponents() {
        
        viewModel.outputs.componets.subscribe(onNext: { [weak self] (componets) in
            
            guard let `self` = self else { return }
            
            self.components = componets
        
        }).disposed(by: disposeBag)
        
    }
    
    init(viewModel: UserDetailViewModel, coordinator: CoordinatorUserDetailProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: UserDetailViewController.typeName , bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let component = components[indexPath.row]
        
        switch component {
        case .user(let user):
            
            let cell = tableView.dequeueReusableCell(with: ProfileTableViewCell.self, for: indexPath)
            cell.configureCell(profile: user)
            
            return cell
            
        case .photos(let photos):
            
            let cell = tableView.dequeueReusableCell(with: PhotosTableViewCell.self, for: indexPath)
            cell.configureCell(images: photos.map({ $0.image }))
            cell.delegate = self
            return cell
            
        }
        
    }

}

extension UserDetailViewController: PhotosTableViewCellDelegate {
    
    func showMore() {
        coordinator.goToPhotosDetail()
    }

}
