//
//  HomeViewController.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

enum Section: String {
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
    func appendItems(task: ModelTask, section: Section)
}

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    private var dataSource: HomeDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ModelTask>!
    var presenter: HomeViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        localizedString()
        configureTableView()
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

    private func localizedString() {
        taskLabel.text = LocalizableString.Home.taskLabel      
        editButton.setTitle(LocalizableString.Home.editButton, for: .normal)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate = self
        
        dataSource = HomeDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            
            cell.configureCell(viewModel: itemIdentifier)
            return cell
        })
        snapshot = dataSource.snapshot()
    }
    
    func showTask(tasks: [ModelTask]) {
        let sections = [Section.Active, Section.Completed]
        snapshot.appendSections(sections)

        for section in sections {
            let items = tasks.filter { task in
                task.type == section
            }
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func appendItems(task: ModelTask, section: Section) {
        snapshot.appendItems([task], toSection: section)
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
        let completedAction = UIContextualAction(style: .normal, title: "Complete") { _, _, _ in
        }
        completedAction.backgroundColor = .systemGreen
        completedAction.image = UIImage(systemName: "checkmark")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [completedAction])
        return swipeConfiguration
    }
}
