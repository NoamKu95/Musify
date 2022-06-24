//
//  WelcomeViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: Constants.Segues.WELCOME_TO_AUTH, sender: self)
    }
 
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == Constants.Segues.WELCOME_TO_AUTH {
            let destinationVC = segue.destination as! AuthViewController
            destinationVC.completionHandler = { [weak self] success in
                DispatchQueue.main.async {
                    self?.handleSignIn(success: success)
                }
            }
        }
      }

    func handleSignIn(success: Bool) {
        // log user in or tell them something went wrong
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.present(self, animated: true)
            return
        }
        let homepage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTabBarController")
        self.present(homepage, animated: true, completion: nil)
    }
}
