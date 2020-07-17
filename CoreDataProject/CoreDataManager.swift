//
//  CoreDataManager.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/3/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataStorage")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of Data: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [NewCompanies] {
        let context = persistentContainer.viewContext
        
        // this line of code fetched the data from coredata into the UI
        
        let fetchRequest = NSFetchRequest<NewCompanies>(entityName: "NewCompanies")
        
        //along with this other lines of code
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
    
    func createEmployee(employeeName: String, birthday: Date, employeeType: String, company: NewCompanies) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        as! Employee
        
        employee.newcompany = company
        employee.type = employeeType
        
        // lets check company is setup corretcly
                
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.taxId = "456"
        
        employeeInformation.birthday = birthday
        
//        employeeInformation.setValue("456", forKey: "taxId")
        
        employee.employeeInformation = employeeInformation
                
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Failed to create employee:", err)
            return (nil, err)
        }
        
    }
}
