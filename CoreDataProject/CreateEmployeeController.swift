//
//  CreateEmployeeController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/21/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

class CreateEmployeeController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        setupNavigationStyle()

        setUpCancelButton()
        
        view.backgroundColor = .darkBlue
    }
}
