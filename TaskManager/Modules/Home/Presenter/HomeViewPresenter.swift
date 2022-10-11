//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import CoreData

protocol HomeViewPresenter {
    func viewDidLoad()
    func configFetchController()
//    func checkEmpty()
    var dataStorage: HomeDataStorage { get }
}

class HomeViewPresenterImp: NSObject, HomeViewPresenter, NSFetchedResultsControllerDelegate {
    
    weak var view: HomeView?
    var dataStorage: HomeDataStorage
    var activeFetchedResultsController: NSFetchedResultsController<ModelTask>!
    var completedFetchedResultsController: NSFetchedResultsController<ModelTask>!

    init(view: HomeView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
   func configFetchController() {
        activeFetchedResultsController = dataStorage.getFetchedResultsController(isActive: true)
        completedFetchedResultsController = dataStorage.getFetchedResultsController(isActive: false)
        activeFetchedResultsController.delegate = self
        completedFetchedResultsController.delegate = self
        do {
            try activeFetchedResultsController.performFetch()
            try completedFetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    func viewDidLoad() {
        let activeTasks = activeFetchedResultsController.fetchedObjects ?? []
        let completedTasks = completedFetchedResultsController.fetchedObjects ?? []
//        checkEmpty()
//        if activeTasks.isEmpty && completedTasks.isEmpty {
//            view?.hideImage(isHidden: false)
//        }
        view?.showTask(activeTasks: activeTasks, completedTasks: completedTasks)
    }
    
    
//    func checkEmpty() {
//        view?.hideImage(isHidden: dataStorage.entityIsEmpty(entityObject: ModelTask.self))
//    }
}

extension HomeViewPresenterImp {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let task = anObject as? ModelTask else { return }
        switch type {
        case .delete:
            view?.deleteTask(tasks: task)
        case .insert:
            view?.insertTask(tasks: task)
        case .move:
            break
        case .update:
            view?.updateTask(tasks: task)
        @unknown default:
            break
        }
    }
}
