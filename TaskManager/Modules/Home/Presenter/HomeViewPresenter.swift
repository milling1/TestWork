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
    func switchTaskState(_ task: ModelTask)
    func deleteTask(_ task: ModelTask)
    var dataStorage: HomeDataStorage { get }
}

class HomeViewPresenterImp: NSObject, HomeViewPresenter, NSFetchedResultsControllerDelegate {
    
    weak var view: HomeView?
    var dataStorage: HomeDataStorage
    var fetchedResultsController: NSFetchedResultsController<ModelTask>!
    
    init(view: HomeView, dataStorage: HomeDataStorage) {
        self.view = view
        self.dataStorage = dataStorage
    }
    
   func configFetchController() {
        fetchedResultsController = dataStorage.getFetchedResultsController()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    func viewDidLoad() {
        configFetchController()
        
        let activeTasks = fetchedResultsController.fetchedObjects?.filter({$0.type}) ?? []
        let completedTasks = fetchedResultsController.fetchedObjects?.filter({!$0.type}) ?? []
        
        view?.hideImage(isHidden: !activeTasks.isEmpty || !completedTasks.isEmpty)
        
        view?.showTask(activeTasks: activeTasks, completedTasks: completedTasks)
    }
    
    func switchTaskState(_ task: ModelTask) {
        task.type.toggle()
        dataStorage.save()
    }
    
    func deleteTask(_ task: ModelTask) {
        dataStorage.deleteTask(task)
    }
    
    private func hideImage() {
        let tasks = fetchedResultsController.fetchedObjects ?? []
        view?.hideImage(isHidden: !tasks.isEmpty)
    }
}

extension HomeViewPresenterImp {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let task = anObject as? ModelTask else { return }
        hideImage()
        
        switch type {
        case .delete:
            view?.deleteTask(tasks: task)
        case .insert:
            view?.insertTask(tasks: task)
        case .move:
            view?.moveTask(task: task)
        case .update:
            view?.updateTask(tasks: task)
        @unknown default:
            break
        }
    }
}
