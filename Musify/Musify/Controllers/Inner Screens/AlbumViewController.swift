//
//  AlbumViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 01/07/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    var album: Album?
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
    }
    
    private func initiateUIElements() {
        
        albumName.text = album?.name
        //albumImage.image = UIImage(album?.images.first?.url)
        
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: backButton, action: #selector(popScreenToGoBack)))
        backButton.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(popScreenToGoBack(tapGestureRecognizer:)))
        backButton.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func popScreenToGoBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
