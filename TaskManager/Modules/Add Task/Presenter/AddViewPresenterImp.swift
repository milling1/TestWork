//
//  AddViewPresenterImp.swift
//  TaskManager
//
//  Created by user on 28.09.2022.
//

import Foundation

protocol AddViewPresenter {
    func createTask(title: String, subtitle: String?, isActive: Bool, uuid: UUID?)
}

class AddViewPresenterImp: AddViewPresenter {
    
    weak private var view: AddTaskView?
    private var dataStorage: HomeDataStorage
    
    init(view: AddTaskView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func createTask(title: String, subtitle: String?, isActive: Bool, uuid: UUID?) {
        dataStorage.createTask(title: title, subtitle: subtitle, isActive: isActive, uuid: uuid)
    }
}
