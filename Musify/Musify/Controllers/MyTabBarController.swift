//
//  ViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabIcons()
    }
    
    func setupTabIcons() {
        
        let iconTabHomepage = self.tabBar.items![0] as UITabBarItem
        iconTabHomepage.selectedImage = UIImage(named: "Homepage-Selected")
        
        let iconTabSearch = self.tabBar.items![1] as UITabBarItem
        iconTabHomepage.selectedImage = UIImage(named: "Homepage-Selected")
        
        let iconTabLibrary = self.tabBar.items![2] as UITabBarItem
        iconTabHomepage.selectedImage = UIImage(named: "Homepage-Selected")

    }


}

