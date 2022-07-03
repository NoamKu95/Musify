//
//  PlaylistHeaderView.swift
//  Musify
//
//  Created by Noam Kurtzer on 03/07/2022.
//

import UIKit

protocol PlaylistHeaderViewDelegate {
    func playAllButtonPressed()
}

class PlaylistHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var playlistDescription: UILabel!
    @IBOutlet weak var playlistOwner: UILabel!
    @IBOutlet weak var playAllButton: UIImageView!
    
    var delegate: PlaylistHeaderViewDelegate?
    var playlist: Playlist?
    
    func initView(delegate: PlaylistHeaderViewDelegate? = nil, playlist: Playlist? = nil) {
        
        self.delegate = delegate
        self.playlist = playlist
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
        playlistName.text = playlist?.name
        playlistOwner.text = playlist?.owner.display_name
        playlistDescription.text = playlist?.description
        playlistImage.sd_setImage(with: URL(string: playlist?.images.first?.url ?? ""))
    }
    
    @objc func playAllButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.playAllButtonPressed()
    }
}
