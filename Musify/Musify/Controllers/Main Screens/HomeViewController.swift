//
//  HomeViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.HOME_TO_SETTINGS, sender: self)
    }
}
