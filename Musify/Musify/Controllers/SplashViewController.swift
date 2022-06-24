//
//  SplashViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    //let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if AuthManager.shared.isSignedIn {
            DispatchQueue.main.async {
                let homepage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTabBarController")
                self.present(homepage, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segues.SPLASH_TO_WELCOME, sender: self)
            }
        }
    }
}
