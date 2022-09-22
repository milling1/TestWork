//
//  HomeBuilder.swift
//  TaskManager
//
//  Created by user on 22.09.2022.
//

import Foundation

protocol HomeBuilder {
    func buildVieController (dataStorage: DataStorage) -> ViewController
}

class HomeBuilderImp: HomeBuilder {
    
    func buildVieController (dataStorage: DataStorage) -> ViewController {
        let controller = ViewController.init(nibName: String(describing: ViewController.self), bundle: nil)
        controller.presenter = HomeViewPresenterImp(view: controller, dataStorage: dataStorage)
        
        return controller
    }
}
