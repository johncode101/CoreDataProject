//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 3/19/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

class CompaniesViewController: UITableViewController {
    
    let companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Goggle", founded: Date())
    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        
        tableView.backgroundColor = UIColor.darkBlue
                
        tableView.separatorColor = .white
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Companies"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        setupNavigationStyle()

    }

    @objc func handleAddCompany() {
                
        let createCompanyController = CreateCompanyController()
                        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
            
        navController.modalPresentationStyle = .fullScreen
            
        present(navController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .tealColor
        
        cell.textLabel?.text = companies[indexPath.row].name // This Line pulls the companies array names into the UI
        
        cell.textLabel?.textColor = .white
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
        
    }

}
