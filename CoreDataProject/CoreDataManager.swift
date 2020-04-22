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
}
