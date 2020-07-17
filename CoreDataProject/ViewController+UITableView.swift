//
//  ViewController+UITableView.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/19/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

extension CompaniesViewController {
    
    //This funcion below sets a new window when row is selected//////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = self.companies[indexPath.row]
        let employeesController = EmployeesController()
        employeesController.company = company
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let delete = deleteAction(at: indexPath)
            let edit = editAction(at: indexPath)
            
            return UISwipeActionsConfiguration(actions: [delete, edit])
        }
    
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    // go over this code one more time
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
        
    }
}
