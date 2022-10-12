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
    func showTask(activeTasks: [ModelTask], completedTasks: [ModelTask])
    func deleteTask(tasks: ModelTask)
    func insertTask(tasks: ModelTask)
    func updateTask(tasks: ModelTask)
    func hideImage(isHidden: Bool)
}

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
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
        presenter.configFetchController()
        configImageView()
        presenter.viewDidLoad()
        addButton.setTitle("", for: .normal)
    }

    @IBAction private func addTaskButton(_ sender: Any) {
        let presenter = presenter.dataStorage
        let addPresenter = AddBuilderImp().buildViewController(dataStorage: presenter)
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
            if itemIdentifier.type {
                cell.configureCell(viewModel: itemIdentifier, backgroundColor: .systemBackground)
                cell.circleLabel.backgroundColor = .systemBackground
            } else {
                cell.configureCell(viewModel: itemIdentifier, backgroundColor: .taskManagerColor)
                cell.changeCompletedTask()
            }
        
            return cell
        })
        snapshot = dataSource.snapshot()
    }
    
    func showTask(activeTasks: [ModelTask], completedTasks: [ModelTask]) {
        snapshot.appendSections([Section.Active, Section.Completed])
        snapshot.appendItems(activeTasks, toSection: .Active)
        snapshot.appendItems(completedTasks, toSection: .Completed)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func deleteTask(tasks: ModelTask) {
        snapshot.deleteItems([tasks])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func insertTask(tasks: ModelTask) {
        let section: Section = tasks.type ? .Active : .Completed
        snapshot.appendItems([tasks], toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateTask(tasks: ModelTask) {
        snapshot.reloadItems([tasks])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
    }
    
    func hideImage(isHidden: Bool) {
        imageView.isHidden = isHidden
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.presenter.deleteTask(item)

            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _,_,completionHandler  in
            
            let presenter = self.presenter.dataStorage
            let addPresenter = AddBuilderImp().buildViewController(dataStorage: presenter, task: self.dataSource.itemIdentifier(for: indexPath))
            self.navigationController?.pushViewController(addPresenter, animated: true)

            completionHandler(true)
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
            self.presenter.updateTask(item)
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
