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
    
    @objc private func doWork() {
    print("Trying to do work..")
    
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...5).forEach { (value) in
                print(value)
                let company = NewCompanies(context: backgroundContext)
                company.name = String(value)
            }
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
                
            } catch let err {
                print("Failed to save:", err)
            }
        })
        
        //GCD - Grand Central Dispatch
        
        DispatchQueue.global(qos: .background).async {
            
//            let context = CoreDataManager.shared.persistentContainer.viewContext
            
        }
    
    }
    
    //lets do some tricky updates with coredata
    
    @objc private func doUpdates() {
        print("Trying to update companies on background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<NewCompanies> = NewCompanies.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "" )
                    company.name = "C: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    //let's try to update the UI after a save
                    DispatchQueue.main.async {
                        
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        // you dont want to refetch everything if you're just simply update on or two companies
                        
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        
                        // is there a way to just merge the chages that you have made to the context
                        
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr {
                    print("Failed to save on the background:", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
                        
        }
    }
    
    //nested parent child context relationship              ****
    @objc private func doNestedUpdates() {
        print("Tryng to perform nested updates now..")
        
        DispatchQueue.global(qos: .background).async {
            // we''ll try to perform our updates
            
            //well first contrct a custom MOC
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            //execuate updtes on private Context now
            
            let request: NSFetchRequest<NewCompanies> = NewCompanies.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    // after save succeeds
                    
                    DispatchQueue.main.async {
                        
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            
                            if context.hasChanges {
                               try context.save()
                            }
                            
                            
                            self.tableView.reloadData()
                        } catch let finalSaveErr {
                            print("failed to save main context:", finalSaveErr)
                        }
                    }
                    
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItems = [

        UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),

        UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
            
        ]
        
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
