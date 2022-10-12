//
//  AddViewPresenterImp.swift
//  TaskManager
//
//  Created by user on 28.09.2022.
//

import Foundation

protocol AddViewPresenter {
    func saveTask(title: String, subtitle: String?, isActive: Bool)
    func present()
    var task: ModelTask? { get }
    
}

class AddViewPresenterImp: AddViewPresenter {
    
    weak private var view: AddTaskView?
    private var dataStorage: HomeDataStorage
    var task: ModelTask? = nil
    
    init(view: AddTaskView, dataStorage: HomeDataStorage, task: ModelTask?) {
        self.view = view
        self.dataStorage = dataStorage
        self.task = task
    }
    
    func saveTask(title: String, subtitle: String?, isActive: Bool) {
        if task == nil {
            dataStorage.createTask(title: title, subtitle: subtitle, isActive: isActive)
        } else {
            dataStorage.updateTask(task!, title: title, subtitle: subtitle, isActive: task!.type)
        }
    }
    
    func present() {
        let title = task?.title ?? ""
        let subtitle = task?.subtitle ?? ""
        view?.configWith(title: title, subtitle: subtitle)
    }
}
