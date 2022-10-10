//
//  HomeViewController.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit
import CoreData

enum Section: String, CaseIterable {
    case Active
    case Completed
    
    func localizedEnum() -> String {
        switch self {
        case .Active:
            return LocalizableString.Home.activeSection
        case .Completed:
            return LocalizableString.Home.completedSection
        }
    }
}

protocol HomeView: AnyObject {
    func showTask()
//    var fetchedResultsController: NSFetchedResultsController<ModelTask>! { get set }
}

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    let imageView = UIImageView()
    
    var activeFetchedResultsController: NSFetchedResultsController<ModelTask>!
    var completedFetchedResultsController: NSFetchedResultsController<ModelTask>!
    private var dataSource: HomeDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ModelTask>!
    var presenter: HomeViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        configureTableView()
        configUI()
        
        configFetchController()
        presenter.viewDidLoad()
        addButton.setTitle("", for: .normal)
    }
   
    @IBAction private func addTaskButton(_ sender: Any) {
        let presenter = presenter.dataStorage
        let addPresenter = AddBuilderImp().buildViewController(dataStorage: presenter as! HomeDataStorageImp)
        navigationController?.pushViewController(addPresenter, animated: true)
    }
    
    @IBAction func editActionButton(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    private func configUI() {
        taskLabel.text = LocalizableString.Home.taskLabel      
        editButton.setTitle(LocalizableString.Home.editButton, for: .normal)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate = self
        
        dataSource = HomeDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            switch indexPath.section {
            case 0:
                cell.configureCell(viewModel: itemIdentifier, backgroundColor: .systemBackground)
                cell.circleLabel.backgroundColor = .systemBackground
            case 1:
                cell.configureCell(viewModel: itemIdentifier, backgroundColor: .taskManagerColor)
                cell.changeCompletedTask()
            default:
                break
            }
            return cell
        })
        snapshot = dataSource.snapshot()
    }
    
    private func configFetchController() {
        activeFetchedResultsController = presenter.dataStorage.getFetchedResultsController(isActive: true)
        completedFetchedResultsController = presenter.dataStorage.getFetchedResultsController(isActive: false)
        activeFetchedResultsController.delegate = self
        completedFetchedResultsController.delegate = self
        do {
            try activeFetchedResultsController.performFetch()
            try completedFetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    func showTask() {
        let activeTasks = activeFetchedResultsController.fetchedObjects ?? []
        if !activeTasks.isEmpty {
            snapshot.appendSections([Section.Active])
            snapshot.appendItems(activeTasks, toSection: Section.Active)
        }
        let completedTasks = completedFetchedResultsController.fetchedObjects ?? []
        if !completedTasks.isEmpty {
            snapshot.appendSections([Section.Completed])
            snapshot.appendItems(completedTasks, toSection: Section.Completed)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        if activeTasks.isEmpty && completedTasks.isEmpty {
            imageView.frame = view.bounds
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Group 21")
            view.addSubview(imageView)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([item])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.presenter.dataStorage.deleteTask(item)

            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _,_,_  in
        }
        
        deleteAction.backgroundColor = .taskManagerColor
        deleteAction.image = UIImage(systemName: "trash")
        
        editAction.backgroundColor = .systemYellow
        editAction.image = UIImage(systemName: "pencil")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfiguration
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
            
        let completedAction = UIContextualAction(style: .normal, title: "Complete") { _, _, completitionHandler in
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([item])
            if snapshot.sectionIdentifiers.contains(.Completed) == false {
                snapshot.appendSections([.Completed])
            }
            snapshot.appendItems([item], toSection: .Completed)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            self.presenter.dataStorage.updateTask(item, title: item.title ?? "", subtitle: item.subtitle, isActive: false, uuid: UUID())
        }
        completedAction.backgroundColor = .systemGreen
        completedAction.image = UIImage(systemName: "checkmark")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [completedAction])
        return swipeConfiguration
    }
    
    func checkTableViewisEmpty() {
        if snapshot.itemIdentifiers(inSection: .Active).isEmpty && snapshot.itemIdentifiers(inSection: .Completed).isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let task = anObject as? ModelTask else { return }
        var snapshot = dataSource.snapshot()
        switch type {
        case .delete:
            snapshot.deleteItems([task])
            let section: Section = task.type ? .Active : .Completed
            if snapshot.itemIdentifiers(inSection: section).isEmpty {
                snapshot.deleteSections([section])
            }
            dataSource.apply(snapshot, animatingDifferences: true)
        case .insert:
            if snapshot.sectionIdentifiers.contains(.Active) == false {
                snapshot.appendSections([Section.Active])
            }
            snapshot.appendItems([task], toSection: .Active)
            dataSource.apply(snapshot, animatingDifferences: true)
        case .move:
            break
        case .update:
            print("print")
//            snapshot.reloadItems([task])
//            dataSource.apply(snapshot, animatingDifferences: true)
        @unknown default:
            break
        }
    }
}
