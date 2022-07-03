//
//  PlaylistViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    var playlist: Playlist?
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var playlistHeader: PlaylistHeaderView!
    
    
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
        getPlaylistData()
    }
    
    private func initiateUIElements() {
        
        // Header
        headerView.initView(delegate: self)
        
        // Playlist Info
        playlistHeader.initView(delegate: self, playlist: self.playlist)
        
        // CollectionView
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Define how the CollectionView will look
        collectionView.frame = view.bounds
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: playlistHeader.bottomAnchor, constant: 12).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func popScreenToGoBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    private func getPlaylistData() {
        if let playlist = playlist {
            ApiCaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.viewModels = model.tracks.items.compactMap({
                            RecommendedTrackCellViewModel(name: $0.track.name, aristName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                        })
                        self?.collectionView.reloadData()
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PlaylistViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - PlaylistHeaderViewDelegate
extension PlaylistViewController : PlaylistHeaderViewDelegate {
    func playAllButtonPressed() {
        print("Button tapped")
    }
}

// MARK: - HeaderViewDelegate
extension PlaylistViewController : HeaderViewDelegate {
    
    func backButtonPressed() {
        self.dismiss(animated: true)
    }
    
    func shareButtonPressed() {
        guard let url = URL(string: playlist?.external_urls["spotify"] as? String ?? "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
}
