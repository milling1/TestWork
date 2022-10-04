//
//  AddViewPresenterImp.swift
//  TaskManager
//
//  Created by user on 28.09.2022.
//

import Foundation

protocol AddViewPresenter {
    func createTask(title: String, description: String?)
}

class AddViewPresenterImp: AddViewPresenter {
    
    weak private var view: AddTaskView?
    private var dataStorage: HomeDataStorage
    
    init(view: AddTaskView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func createTask(title: String, description: String?) {
        let task = ModelTask(title: title, description: description, type: .Active)
        dataStorage.addTask(task)
    }
}
