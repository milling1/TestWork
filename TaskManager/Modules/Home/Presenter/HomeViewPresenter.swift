//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

protocol HomeViewPresenter {
    func viewDidLoad()
    var dataStorage:HomeDataStorage { get }
}

class HomeViewPresenterImp: HomeViewPresenter {
    
    weak var view: HomeView?
    var dataStorage: HomeDataStorage
    
    init(view: HomeView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
    func viewDidLoad() {
        view?.showTask(tasks: dataStorage.tasks)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRecieved), name: NSNotification.Name.taskWasAdded , object: nil)
    }
    
    @objc func notificationRecieved() {
        if let task = dataStorage.tasks.last {
            view?.appendItems(task: task, section: .Active)
        }
    }
}
