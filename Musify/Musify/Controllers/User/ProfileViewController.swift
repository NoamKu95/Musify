//
//  ProfileViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var presentProfileLabel: UILabel!
    @IBOutlet weak var sideArrowImageView: UIImageView!
    
    
    
    var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserProfile()
        initiateUIElements()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchUserProfile() {
        ApiCaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                self.updateUI(with: model)
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.failedToFetchProfile()
                break
            }
        }
    }
    
    func updateUI(with model: UserProfile) {
        DispatchQueue.main.async {
            self.models.append("Country: \(model.country)")
            self.models.append("Email: \(model.email)")
            self.models.append("ID: \(model.id)")
            self.models.append("Product: \(model.product)")
            self.populateUserProfileDetails(withImageURL: model.images.first?.url, userName: model.display_name)
            self.tableView.reloadData()
        }
    }
    
    func populateUserProfileDetails(withImageURL url: String?, userName: String) {
        guard let urlString = url, let url = URL(string: urlString) else {
            return
        }
        profilePictureImageView.sd_setImage(with: url)
        userNameLabel.text = userName
    }
    
    func failedToFetchProfile() {
        
    }
    
    func initiateUIElements() {
        headerView.initView(headerType: .backOnly)
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-profile", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        
        return cell
    }
    
}
