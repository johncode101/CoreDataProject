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
    
    func didEditCompany(company: NewCompanies) {
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)

    }
    

    func didAddCompany(company: NewCompanies) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
    
    var companies = [NewCompanies]()
    
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let delete = deleteAction(at: indexPath)
            let edit = editAction(at: indexPath)
            
            return UISwipeActionsConfiguration(actions: [delete, edit])
        }


    //delete
        func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
                
                let company = self.companies[indexPath.row]
                
                self.companies.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(company)
                
                do {
                    try context.save()
                } catch let deleteErr {
                    print("Failed to delete company", deleteErr)
                }
                
                completionHandler(true)
            }
            
            delete.backgroundColor = .red
            return delete
            
        }

    //edit
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let editCompanyController = CreateCompanyController()
            editCompanyController.delegate = self
            editCompanyController.company = self.companies[indexPath.row]
            let layout = CustomNavigationController(rootViewController: editCompanyController)
            
            editCompanyController.delegate = self
            
            self.present(layout, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        editAction.backgroundColor = .darkBlue
        return editAction
    }
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
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
    
    @objc private func handleReset() {
        print("Atempting to print out all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
//        companies.forEach { (company) in
//            context.delete(company)
//
//        }
        
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
//            companies.removeAll()
//            tableView.reloadData()
            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available.."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }

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
        // This Line pulls the companies array names into the UI
        cell.textLabel?.text = companies[indexPath.row].name
        
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            
            let dateFormatter = DateFormatter ()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let foundedDateString = dateFormatter.string(from: founded)
            let dateString = "\(name) - founded: \(foundedDateString)"
            
            cell.textLabel?.text = dateString
            
        } else {
            
            cell.textLabel?.text = company.name
            
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
        
    }

}
