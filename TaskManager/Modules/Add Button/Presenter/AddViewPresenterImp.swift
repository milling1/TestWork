//
//  AddViewPresenterImp.swift
//  TaskManager
//
//  Created by user on 28.09.2022.
//

import Foundation

protocol AddViewPresenter {
    var dataStorage: DataStorage { get }
    func createTaskMVP(title: String, description: String?)
}

class AddViewPresenterImp: AddViewPresenter {
    
    weak var create: AddTaskView?
    var dataStorage: DataStorage
    
    init(create: AddTaskView, dataStorage: DataStorage) {
        self.create = create
        self.dataStorage = dataStorage
    }
    
    func createTaskMVP(title: String, description: String?) {
        let task = ModelTask(title: title, description: description, type: .Active)
        dataStorage.addTask(task)
    }
}
