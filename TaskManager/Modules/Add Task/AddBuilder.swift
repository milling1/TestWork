//
//  AddBuilder.swift
//  TaskManager
//
//  Created by user on 29.09.2022.
//

import Foundation

protocol AddBuilder {
    func buildViewController(dataStorage: DataStorage) -> AddTaskViewController
}

class AddBuilderImp: AddBuilder {
    
    func buildViewController(dataStorage: DataStorage) -> AddTaskViewController {
        let controller = AddTaskViewController.init(nibName: String(describing: AddTaskViewController.self), bundle: nil)
        controller.presenter = AddViewPresenterImp(view: controller, dataStorage: dataStorage)
        return controller
    }
}
