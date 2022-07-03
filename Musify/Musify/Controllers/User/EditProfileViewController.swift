//
//  EditProfileViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 03/07/2022.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.initView(delegate: self, headerType: .backOnly)
    }

    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
        print("OPEN GALLERY")
    }
    
}

// MARK: - HeaderViewDelegate
extension EditProfileViewController : HeaderViewDelegate {
    
    func backButtonPressed() {
        self.dismiss(animated: true)
    }
}
