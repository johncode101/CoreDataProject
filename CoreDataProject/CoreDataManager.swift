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
}
