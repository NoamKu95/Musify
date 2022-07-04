//
//  AlbumViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 01/07/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    var album: Album?
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var albumHeader: PlaylistAlbumHeaderView!
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider:{ _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(65)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
        getAlbumData()
    }
    
    private func initiateUIElements() {
        
        // App Header
        headerView.initView(delegate: self, headerType: .backOnly)

        // Album Header
        albumHeader.initView(delegate: self, album: self.album)
        
        // CollectionView
        view.addSubview(collectionView)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Define how the CollectionView will look
        collectionView.frame = view.alignmentRect(forFrame: CGRect(x: 0, y: albumHeader.bottom, width: view.width, height: view.height - albumHeader.height - headerView.height))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: albumHeader.bottomAnchor, constant: 12).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    private func getAlbumData() {
        if let album = album {
            ApiCaller.shared.getAlbumDetails(for: album) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.viewModels = model.tracks.items.compactMap({
                            AlbumCollectionViewCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-")
                        })
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - HeaderViewDelegate
extension AlbumViewController : HeaderViewDelegate {
    
    func backButtonPressed() {
        self.dismiss(animated: true)
    }
}

// MARK: - PlaylistAlbumHeaderViewDelegate
extension AlbumViewController : PlaylistAlbumHeaderViewDelegate {
    
    func playAllButtonPressed() {
        print("PLAY MUSIC")
    }
}
