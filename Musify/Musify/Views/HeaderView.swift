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
    func settingsButtonPressed()
}

extension HeaderViewDelegate {
    func backButtonPressed() {}
    func shareButtonPressed() {}
    func settingsButtonPressed() {}
}

enum HeaderButtonsType {
    case homepage
    case backOnly
    case share
}

class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var settingsButton: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    
    var delegate: HeaderViewDelegate?
    
    func initView(delegate: HeaderViewDelegate? = nil, headerType: HeaderButtonsType) {
        
        self.delegate = delegate
        commonInit()
        initiateIcons(basedOn: headerType)
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    func initiateIcons(basedOn headerType: HeaderButtonsType) {
        
        backButton.isHidden = true
        shareButton.isHidden = true
        settingsButton.isHidden = true
        
        switch headerType {
        case .homepage:
            settingsButton.isHidden = false
            settingsButton.isUserInteractionEnabled = true
            settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: settingsButton, action: #selector(settingsButtonTapped)))
            let tapRecognizer3 = UITapGestureRecognizer(target:self,action:#selector(settingsButtonTapped(tapGestureRecognizer:)))
            settingsButton.addGestureRecognizer(tapRecognizer3)
            
        case .backOnly:
            backButton.isHidden = false
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(UITapGestureRecognizer(target: backButton, action: #selector(backButtonTapped)))
            let tapRecognizer1 = UITapGestureRecognizer(target:self,action:#selector(backButtonTapped(tapGestureRecognizer:)))
            backButton.addGestureRecognizer(tapRecognizer1)
            
        case .share:
            shareButton.isHidden = false
            shareButton.addGestureRecognizer(UITapGestureRecognizer(target: shareButton, action: #selector(shareButtonTapped)))
            shareButton.isUserInteractionEnabled = true
            let tapRecognizer2 = UITapGestureRecognizer(target:self,action:#selector(shareButtonTapped(tapGestureRecognizer:)))
            shareButton.addGestureRecognizer(tapRecognizer2)
            backButton.isHidden = false
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(UITapGestureRecognizer(target: backButton, action: #selector(backButtonTapped)))
            let tapRecognizer1 = UITapGestureRecognizer(target:self,action:#selector(backButtonTapped(tapGestureRecognizer:)))
            backButton.addGestureRecognizer(tapRecognizer1)
        }
    }
    
    
    // MARK: - Button Pressed Functions
    
    @objc func backButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.backButtonPressed()
    }
    
    @objc func shareButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.shareButtonPressed()
    }
    
    @objc func settingsButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.settingsButtonPressed()
    }
    
}
