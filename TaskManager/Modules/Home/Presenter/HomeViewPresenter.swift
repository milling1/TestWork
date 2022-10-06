//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

protocol HomeViewPresenter {
    func viewDidLoad()
    var dataStorage: HomeDataStorage { get }
}

class HomeViewPresenterImp: HomeViewPresenter {
    
    weak var view: HomeView?
    var dataStorage: HomeDataStorage

    init(view: HomeView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func viewDidLoad() {
        let tasks = view?.fetchedResultsController.fetchedObjects ?? [ModelTask]()
        view?.showTask(tasks: tasks)
    }
}
