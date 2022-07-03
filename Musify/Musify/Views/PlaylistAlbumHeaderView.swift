//
//  PlaylistHeaderView.swift
//  Musify
//
//  Created by Noam Kurtzer on 03/07/2022.
//

import UIKit

protocol PlaylistAlbumHeaderViewDelegate {
    func playAllButtonPressed()
}

class PlaylistAlbumHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var playAllButton: UIImageView!
    
    var delegate: PlaylistAlbumHeaderViewDelegate?
    
    var playlist: Playlist?
    var album: Album?
    
    func initView(delegate: PlaylistAlbumHeaderViewDelegate? = nil, playlist: Playlist? = nil, album: Album? = nil) {
        self.delegate = delegate
        self.playlist = playlist
        self.album = album
        commonInit()
    }
    
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("PlaylistHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
        
        // Initiate Play Button Press
        playAllButton.addGestureRecognizer(UITapGestureRecognizer(target: playAllButton, action: #selector(playAllButtonTapped)))
        playAllButton.isUserInteractionEnabled = true
        let tapRecognizer1 = UITapGestureRecognizer(target:self,action:#selector(playAllButtonTapped(tapGestureRecognizer:)))
        playAllButton.addGestureRecognizer(tapRecognizer1)
        
        // Populate Fields
        if let playlist = playlist {
            name.text = playlist.name
            owner.text = playlist.owner.display_name
            descriptionLabel.text = playlist.description
            image.sd_setImage(with: URL(string: playlist.images.first?.url ?? ""))
        } else if let album = album {
            name.text = album.name
            
            image.sd_setImage(with: URL(string: album.images.first?.url ?? ""))
        }
        
    }
    
    @objc func playAllButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.playAllButtonPressed()
    }
}
