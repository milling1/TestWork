//
//  AddBuilder.swift
//  TaskManager
//
//  Created by user on 29.09.2022.
//

import Foundation

protocol AddBuilder {
    func buildViewController(dataStorage: HomeDataStorage, task: ModelTask?) -> AddTaskViewController
}

extension AddBuilder {
    func buildViewController(dataStorage: HomeDataStorage, task: ModelTask? = nil) -> AddTaskViewController {
        buildViewController(dataStorage: dataStorage, task: task)
    }
}

class AddBuilderImp: AddBuilder {
    
    func buildViewController(dataStorage: HomeDataStorage, task: ModelTask?) -> AddTaskViewController {
        let controller = AddTaskViewController.init(nibName: String(describing: AddTaskViewController.self), bundle: nil)
        controller.presenter = AddViewPresenterImp(view: controller, dataStorage: dataStorage, task: task)
        return controller
    }
}
