//
//  SearchViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        return NSCollectionLayoutSection(group: group)
    }))
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
    }
    
    private func initUIElements() {
        headerView.initView(delegate: self, headerType: .homepage)
        
        searchBar.inputViewController?.definesPresentationContext = true
        searchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.alignmentRect(forFrame: CGRect(x: 0, y: searchBar.bottom, width: view.width, height: view.height-headerView.height-searchBar.height-100))
    }
}

// MARK: - HeaderViewDelegate
extension SearchViewController : HeaderViewDelegate {
    
}

// MARK: - SearchViewController
extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    //Everytime text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchtext: String) {
        
        if (searchtext.trimmingCharacters(in: .whitespaces).isEmpty) {
            return
        }
        
        // Perform search
//        ApiCaller.shared.search
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: "Genre")
        return cell
    }
}
