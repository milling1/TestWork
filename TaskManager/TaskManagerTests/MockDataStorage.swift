//
//  MockDataStorage.swift
//  TaskManagerTests
//
//  Created by user on 13.10.2022.
//

import XCTest
@testable import TaskManager
import CoreData

class MockDataStorage: HomeDataStorage {

    var isCreateTaskCalled = false
    var isDeleteTaskCalled = false
    var isUpdateTaskCalled = false
    var taskManagerModeltask = [TaskManager.ModelTask]()
    var isSaveTaskCalled = false
    var isRollbackTaskCalled = false
    var isDeleteAllTaskCalled = false
  
    func getFetchedResultsController() -> NSFetchedResultsController<TaskManager.ModelTask> {
        return NSFetchedResultsController()
    }
    
    func createTask(title: String, subtitle: String?, isActive: Bool) -> TaskManager.ModelTask? {
        var task = ModelTask()
        task.title = title
        task.subtitle = subtitle
        task.type = isActive
        isCreateTaskCalled = true
        return task
    }
    
    func deleteTask(_ task: TaskManager.ModelTask) {
        isDeleteTaskCalled = true
    }
    
    func getTaskById(_ id: NSManagedObjectID) -> TaskManager.ModelTask? {
        return nil
    }
    
    func updateTask(_ task: ModelTask, title: String, subtitle: String?, isActive: Bool) {
        task.title = title
        task.subtitle = subtitle
        task.type = isActive
        isUpdateTaskCalled = true
    }
    
    func fetchTasks() -> [TaskManager.ModelTask] {
        return taskManagerModeltask
    }
    
    func save() {
        isSaveTaskCalled = true
    }
    
    func rollback() {
        isRollbackTaskCalled = true
    }
    
    func deleteAllTasks() {
        isDeleteAllTaskCalled = false
    }
}
