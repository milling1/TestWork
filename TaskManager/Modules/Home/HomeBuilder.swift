//
//  HomeBuilder.swift
//  TaskManager
//
//  Created by user on 22.09.2022.
//

import Foundation

protocol HomeBuilder {
    func buildViewController(dataStorage: DataStorage) -> HomeViewController
}

class HomeBuilderImp: HomeBuilder {
    
    func buildViewController(dataStorage: DataStorage) -> HomeViewController {
        let controller = HomeViewController.init(nibName: String(describing: HomeViewController.self), bundle: nil)
        controller.presenter = HomeViewPresenterImp(view: controller, dataStorage: dataStorage)
        return controller
    }
}
