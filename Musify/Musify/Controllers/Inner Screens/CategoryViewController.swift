//
//  CategoryViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 04/07/2022.
//

import UIKit

class CategoryViewController: UIViewController {

    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return NSCollectionLayoutSection(group: group)
    }))
    
    var category: Category?
    var playlists = [Playlist]()
    private var selectedPlaylist: Playlist?
    
    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateUIElements()
        fetchCategoryPlaylists()
    }

    private func initiateUIElements() {
        // App Header
        headerView.initView(delegate: self, headerType: .backOnly)
        
        // CollectionView
        view.addSubview(collectionView)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.alignmentRect(forFrame: CGRect(x: 0, y: headerView.bottom, width: view.width, height: view.height-headerView.height))
    }
    
    private func fetchCategoryPlaylists() {
        ApiCaller.shared.getCategoryPlaylists(categoryID: category?.id ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - HeaderViewDelegate
extension CategoryViewController : HeaderViewDelegate {
    
    func backButtonPressed() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(name: playlist.name, artworkURL: URL(string: playlist.images.first?.url ?? ""), creatorName: playlist.owner.display_name))
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedPlaylist = playlists[indexPath.row]
        self.performSegue(withIdentifier: Constants.Segues.CATEGORY_TO_PLAYLIST, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.CATEGORY_TO_PLAYLIST && self.selectedPlaylist != nil {
            let destinationVC = segue.destination as! PlaylistViewController
            destinationVC.playlist = self.selectedPlaylist
            self.selectedPlaylist = nil
        }
    }
}
