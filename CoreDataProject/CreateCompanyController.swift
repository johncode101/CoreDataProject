//
//  CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 3/26/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

class CreateCompanyController: UITableViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
//        label.backgroundColor = .tealColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
            
        tableView.backgroundColor = UIColor.darkBlue
                    
        tableView.separatorColor = .white
            
        tableView.tableFooterView = UIView()
            
        navigationItem.title = "Create Company"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        setupNavigationStyle()
        
        setupUI()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
    }
    
    private func setupUI() {
        
        let lightBlueBackGroundView = UIView()
        
        view.addSubview(lightBlueBackGroundView)
        lightBlueBackGroundView.backgroundColor = UIColor.lightBlue
        
        lightBlueBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        
        lightBlueBackGroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        lightBlueBackGroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lightBlueBackGroundView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lightBlueBackGroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        view.addSubview(nameLabel)
//        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
        
    }
}

extension UIViewController {
    
        func setupNavigationStyle() {
        
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .darkBlue
        appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white] //portrait title
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white] //landscape title
        navigationController?.navigationBar.standardAppearance = appearance //landscape
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance //portrait    }
        
    }
}
