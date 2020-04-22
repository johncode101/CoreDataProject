//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 3/19/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData

//This lines of code are responsible for handing off the resposiblities of the createcompanycontrollerdelegate declared on createcompanycontroller and setting up onto the index row path for the UI

class CompaniesViewController: UITableViewController {
    
    var companies = [NewCompanies]()


    // This function will be responsible for fetching the data onto the UI

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = UIColor.darkBlue
                
        tableView.separatorColor = .white
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Companies"
        
        setUpPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")

        setupNavigationStyle()

    }
    
    //This function handles the navigation between controller when the add button is pressed
    
    @objc private func handleReset() {
        print("Atempting to print out all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NewCompanies.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
        
    }

    @objc func handleAddCompany() {
                
        let createCompanyController = CreateCompanyController()
                        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        navController.modalPresentationStyle = .fullScreen
            
        present(navController, animated: true, completion: nil)
    }

}
