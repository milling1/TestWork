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
    func showTask(tasks: [ModelTask])
    var fetchedResultsController: NSFetchedResultsController<ModelTask>! { get set }
}

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<ModelTask>!
    private var dataSource: HomeDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ModelTask>!
    private var dataStorage = HomeDataStorageImp()
    var presenter: HomeViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        configUI()
        configureTableView()
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
        
        dataSource = HomeDataSource(dataStorage: dataStorage, tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
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
        fetchedResultsController = dataStorage.getFetchedResultsController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    func showTask(tasks: [ModelTask]) {
        snapshot.appendSections([Section.Active, Section.Completed])
        for task in tasks {
            if task.type == true {
                snapshot.appendItems([task], toSection: Section.Active)
            } else {
                snapshot.appendItems([task], toSection: Section.Completed)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
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
            self.dataStorage.deleteTask(item)

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
            snapshot.appendItems([item], toSection: .Completed)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            self.dataStorage.updateTask(item, title: item.title ?? "", subtitle: item.subtitle, type: false, uuid: UUID())
        }
        
        completedAction.backgroundColor = .systemGreen
        completedAction.image = UIImage(systemName: "checkmark")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [completedAction])
        return swipeConfiguration
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
                dataSource.apply(snapshot, animatingDifferences: true)
            case .insert:
            snapshot.appendItems([task], toSection: .Active)
                dataSource.apply(snapshot, animatingDifferences: true)
            case .move:
                break
            case .update:
                snapshot.reloadItems([task])
                dataSource.apply(snapshot, animatingDifferences: true)
            @unknown default:
                break
        }
    }
}
