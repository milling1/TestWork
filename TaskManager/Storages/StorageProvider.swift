//
//  StorageProvider.swift
//  TaskManager
//
//  Created by user on 05.10.2022.
//

import CoreData

class StorageProvider {
    
    static let shared = StorageProvider()
    var persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ModelTask")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Nu se salveaza")
        }
    }
}
