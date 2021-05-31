//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

class HomeSceneViewController: UIViewController {
    
    // MARK: - Properties
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    var viewModels: [HomeScene.Search.ViewModel]?
    var layoutType: HomeScene.LayoutType? {
        didSet {
            collectionView.setCollectionViewLayout(layoutType == .list ? ListCollectionViewFlowLayout() : GridCollectionViewFlowLayout(), animated: true)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        layoutType = .list // set default layout
        setupCollectionView()
        setupNavigationItem()
        
        // fetch Data
        interactor?.fetchCharacters()
    }
    
    // MARK: - Helper
    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Layout", style: .plain, target: self, action: #selector(changeLayoutTapped))
    }
    
    func setupCollectionView() {
        collectionView.register(HomeCharacterCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCharacterCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Selector
    @objc func changeLayoutTapped(_ sender: UIBarButtonItem) {
        layoutType = layoutType == .list ? .peek : .list
    }
}

extension HomeSceneViewController: HomeSceneDisplayView {
    func didFetchCharacters(viewModels: [HomeScene.Search.ViewModel]) {
        // TODO: Implement
        self.viewModels = viewModels
        self.collectionView.reloadData()
    }
    
    func failedToFetchCharacters(error: Error) {
        // TODO: Implement
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeSceneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCharacterCollectionViewCell, let viewModel = viewModels?[indexPath.row] else {
            fatalError("it should not be like that")
        }
        
        cell.configure(with: viewModel)
        return cell
    }
}

extension HomeSceneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToCharacterDetailsWithCharacter(at: indexPath.row)
    }
}

// Parent flow layout class for the common functionalities
class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 10
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
}

// Child flow layout class for the list style
class ListCollectionViewFlowLayout: CollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
}

// Child flow layout class for the grid style
class GridCollectionViewFlowLayout: CollectionViewFlowLayout {
        
    override init() {
        super.init()
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.85)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
}
