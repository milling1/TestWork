//
//  MockHomeView.swift
//  TaskManagerTests
//
//  Created by user on 13.10.2022.
//

import XCTest
@testable import TaskManager
import CoreData

class MockHomeView: HomeView {
   
    
    
    var activeTaskTest: [ModelTask]?
    var completedTasktest: [ModelTask]?
    var isImageNotHidden: Bool = false
    var isShowTaskCall: Bool = false
    var isDeleteTaskCall: Bool = false
    var isInsertTaskCall: Bool = false
    var isMoveTaskCall: Bool = false
    var isUpdateTaskCall: Bool = false
    var isDidChangeSection: Bool = false
    
    func showTask(activeTasks: [TaskManager.ModelTask], completedTasks: [TaskManager.ModelTask]) {
        activeTaskTest = activeTasks
        completedTasktest = completedTasks
        isShowTaskCall = true
    }
    
    func deleteTask(tasks: TaskManager.ModelTask) {
        isDeleteTaskCall = true
    }
    
    func insertTask(tasks: TaskManager.ModelTask) {
        isInsertTaskCall = true
    }
    
    func moveTask(task: TaskManager.ModelTask) {
        isMoveTaskCall = true
    }
    
    func updateTask(tasks: TaskManager.ModelTask) {
        isUpdateTaskCall = true
    }
    
    func didChangeSection(task: ModelTask) {
        isDidChangeSection = true
    }
    
    func hideImage(isHidden: Bool) {
        isImageNotHidden = isHidden
    }
}
