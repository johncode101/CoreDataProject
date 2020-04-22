//
//  ViewController+CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/18/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

extension CompaniesViewController: CreateCompanyControllerDelegate {
    
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
    
}
