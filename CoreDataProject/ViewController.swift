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

class CompaniesViewController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: NewCompanies) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    var companies = [NewCompanies]()
    
    // This function will be responsible for fetching the data onto the UI
    
    private func fetchCompanies() {
        
        // This line of code bring the persistent container stack on to the fetching func

        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // this line of code fetched the data from coredata into the UI
        
        let fetchRequest = NSFetchRequest<NewCompanies>(entityName: "NewCompanies")
        
        //along with this other lines of code
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            companies.forEach({ (NewCompanies) in
                print(NewCompanies.name ?? "")
            })
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
         fetchCompanies()
                
        view.backgroundColor = .white
        
        tableView.backgroundColor = UIColor.darkBlue
                
        tableView.separatorColor = .white
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Companies"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        setupNavigationStyle()

    }
    
    //This function handles the navigation between controller when the add button is pressed

    @objc func handleAddCompany() {
                
        let createCompanyController = CreateCompanyController()
                        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
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
