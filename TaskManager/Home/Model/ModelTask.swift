//
//  ModelTask.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

struct ModelTask: Hashable {
    var task: String
    
    
    
    static func testDataActive() -> [ModelTask] {
        return [
            ModelTask(task: "Go for run \nRun for at least 5 km today"),
            ModelTask(task: "Read chapter 7 from the new book"),
            ModelTask(task: "Practice guitar \nAt least 20 min today")
        ]
    }
    
    static func testDataCompleted() -> [ModelTask] {
        return [
            ModelTask(task: "Schedule a dentist appointment \nSaturday at 14:00"),
            ModelTask(task: "PLay the piano \nPractice 2 new pieces")
        ]
    }
}






