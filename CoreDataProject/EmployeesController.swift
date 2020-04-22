//
//  EmployeesController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/19/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: NewCompanies?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.yellow
        
        setUpPlusButtonInNavBar(selector: #selector(handleAdd))
        
    }
    
    @objc private func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        print("adding something")
    }
}
