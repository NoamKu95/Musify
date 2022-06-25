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
        getData()
    }
    
    func getData() {
        ApiCaller.shared.getNewReleases { result in
            switch result {
            case .success(let model):
                //print(model)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        ApiCaller.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let model):
                //print(model)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        ApiCaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                ApiCaller.shared.getRecommendations(genres: seeds) { result in
                    switch result {
                    case .success(let model):
                        //print(model)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.HOME_TO_SETTINGS, sender: self)
    }
}
