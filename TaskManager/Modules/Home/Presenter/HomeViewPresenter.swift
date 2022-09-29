//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

protocol HomeViewPresenter {
    func viewDidLoad()
    var dataStorage: DataStorage { get }
}

class HomeViewPresenterImp: HomeViewPresenter {
    
    weak var view: HomeView?
    
    var dataStorage: DataStorage
    
    init(view: HomeView, dataStorage: DataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func viewDidLoad() {
        view?.showTask(tasks: dataStorage.tasks)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRecieved), name: NSNotification.Name(rawValue: "task was added"), object: nil)
    }
    
    @objc func notificationRecieved() {
        if let task = dataStorage.tasks.last {
            view?.appendItems(task: task, section: .Active)
        }
    }
}
