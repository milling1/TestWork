//
//  DataStorage.swift
//  TaskManager
//
//  Created by user on 20.09.2022.
//

import Foundation

protocol HomeDataStorage {
    func addTask(_ task: ModelTask)
    var tasks: [ModelTask] { get }
}

class HomeDataStorageImp: HomeDataStorage {
    
    var tasks = [ ModelTask(title: "Go for run", description: "Run for at least 5 km today", type: .Active),
                  ModelTask(title: "Read chapter 7 from the new book", type: .Active),
                  ModelTask(title: "Practice guitar", description: "At least 20 min today", type: .Active),
                  ModelTask(title: "Schedule a dentist appointment", description: "Saturday at 14:00", type: .Completed),
                  ModelTask(title: "PLay the piano", description: "Practice 2 new pieces", type: .Completed)
    ]
    
    func addTask(_ task: ModelTask) {
        tasks.append(task)
        NotificationCenter.default.post(name: NSNotification.Name.taskWasAdded, object: nil)
    }
}
