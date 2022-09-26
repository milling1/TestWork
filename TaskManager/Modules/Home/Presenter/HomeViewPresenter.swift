//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

protocol HomeViewPresenter {
    func viewDidLoad()
}

class HomeViewPresenterImp: HomeViewPresenter {
    
    weak var view: HomeView?
    
    private var dataStorage: DataStorage
    
    init(view: HomeView, dataStorage: DataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func viewDidLoad() {
        view?.showTask(tasks: dataStorage.tasks)
    }
}
