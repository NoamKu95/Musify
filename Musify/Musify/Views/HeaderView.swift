//
//  HeaderView.swift
//  Musify
//
//  Created by Noam Kurtzer on 03/07/2022.
//

import UIKit

protocol HeaderViewDelegate {
    func backButtonPressed()
    func shareButtonPressed()
}

extension HeaderViewDelegate {
    func backButtonPressed() {}
    func shareButtonPressed() {}
}

class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    
    var delegate: HeaderViewDelegate?
    
    func initView(delegate: HeaderViewDelegate? = nil) {
        
        self.delegate = delegate
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
        
        initiateButtonsTaps()
        //initiateUIElements()
    }
    
    func initiateButtonsTaps() {
        // Back Button
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: backButton, action: #selector(backButtonTapped)))
        backButton.isUserInteractionEnabled = true
        let tapRecognizer1 = UITapGestureRecognizer(target:self,action:#selector(backButtonTapped(tapGestureRecognizer:)))
        backButton.addGestureRecognizer(tapRecognizer1)
        
        // Share Button
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: shareButton, action: #selector(shareButtonTapped)))
        shareButton.isUserInteractionEnabled = true
        let tapRecognizer2 = UITapGestureRecognizer(target:self,action:#selector(shareButtonTapped(tapGestureRecognizer:)))
        shareButton.addGestureRecognizer(tapRecognizer2)
    }
    
    func initiateUIElements() {
        backButton.isHidden = true
        shareButton.isHidden = false
    }
    
    @objc func backButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.backButtonPressed()
    }
    
    @objc func shareButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.shareButtonPressed()
    }
    
}
