//
//  DataStorage.swift
//  TaskManager
//
//  Created by user on 20.09.2022.
//

import Foundation
import CoreData

protocol HomeDataStorage {
    func getFetchedResultsController(isActive: Bool) -> NSFetchedResultsController<ModelTask>
    @discardableResult
    func createTask(title: String, subtitle: String?, isActive: Bool) -> ModelTask?
    func deleteTask(_ task: ModelTask)
    func getTaskById(_ id: NSManagedObjectID) -> ModelTask?
    func updateTask(_ task: ModelTask, title: String, subtitle: String?, isActive: Bool)
    func fetchTasks() -> [ModelTask]
    func save()
    func rollback()
    func deleteAllTasks()
}

class HomeDataStorageImp: HomeDataStorage {
   
    private let context: NSManagedObjectContext

    init() {
        context = StorageProvider.shared.persistentContainer.viewContext
    }

    func getFetchedResultsController(isActive: Bool) -> NSFetchedResultsController<ModelTask> {
        let request = ModelTask.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "type == %@", NSNumber(value: isActive))
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }

    @discardableResult
    func createTask(title: String, subtitle: String?, isActive: Bool) -> ModelTask? {
        let entity = ModelTask(context: context)
        entity.title = title
        entity.subtitle = subtitle
        entity.type = isActive
        
        save()
        return entity
    }

    func deleteTask(_ task: ModelTask) {
        context.delete(task)
        save()
    }

    func getTaskById(_ id: NSManagedObjectID) -> ModelTask? {
        guard let entity =  try? context.existingObject(with: id),
              let modeltask = entity as? ModelTask else {
            return nil
        }
        return modeltask
    }

    func fetchTasks() -> [ModelTask] {
        let fetchRequest = ModelTask.fetchRequest()
        guard let entities = try? context.fetch(fetchRequest) else {
            return []
        }

        return entities
    }

    func updateTask(_ task: ModelTask, title: String, subtitle: String?, isActive: Bool) {
        task.title = title
        task.subtitle = subtitle
        task.type = isActive
        
        save()
    }

    func save() {
        StorageProvider.shared.save()
    }

    func rollback() {
        context.rollback()
    }

    func deleteAllTasks() {
        StorageProvider.shared.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ModelTask.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
               try context.execute(deleteRequest)
            } catch let error as NSError {
                print("Not deleted \(error)")
            }
        }
    }
}
