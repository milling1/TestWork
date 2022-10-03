//
//  AddViewPresenterImp.swift
//  TaskManager
//
//  Created by user on 28.09.2022.
//

import Foundation

protocol AddViewPresenter {
    func createTaskMVP(title: String, description: String?)
}

class AddViewPresenterImp: AddViewPresenter {
    
    weak private var view: AddTaskView?
    private var dataStorage: DataStorage
    
    init(view: AddTaskView, dataStorage: DataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func createTaskMVP(title: String, description: String?) {
        let task = ModelTask(title: title, description: description, type: .Active)
        dataStorage.addTask(task)
    }
}
