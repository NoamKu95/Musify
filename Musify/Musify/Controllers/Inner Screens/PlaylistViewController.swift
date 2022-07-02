//
//  PlaylistViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    var playlist: Playlist?
    
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var playlistImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateUIElements()
        getPlaylistData()
    }
    
    private func initiateUIElements() {
        
        playlistName.text = playlist?.name
        //playlistImage.image = UIImage(playlist?.images.first?.url)
        
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: backButton, action: #selector(popScreenToGoBack)))
        backButton.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(popScreenToGoBack(tapGestureRecognizer:)))
        backButton.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func popScreenToGoBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    private func getPlaylistData() {
        if let playlist = playlist {
            ApiCaller.shared.getPlaylistDetails(for: playlist) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        break
                    case .failure(let error):
                        break
                    }
                }
            }
        }
    }
}
