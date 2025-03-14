//
//  Persistence.swift
//  CoreDataDemo
//
//  Created by Nat Kim on 3/14/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()


    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Products")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
