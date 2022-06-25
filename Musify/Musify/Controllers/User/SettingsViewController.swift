//
//  SettingsViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureModels() {
        sections.append(
            Section(title: "Profile",
                    options: [
                        Option(title: "View your profile", handler: { [weak self] in
                            self?.performSegue(withIdentifier: Constants.Segues.SETTINGS_TO_PROFILE, sender: self)
                        })]))
        
        sections.append(
            Section(title: "Account",
                    options: [
                        Option(title: "sign Out", handler: { [weak self] in
                            print("log user out")
                        })]))
    }
    
    
    @IBAction func profileTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.SETTINGS_TO_PROFILE, sender: self)
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    
}
