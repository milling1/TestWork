//
//  HomeViewController.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

enum Section: String, CaseIterable {
    case Active
    case Completed
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title: Section) -> String {
        return title.localizedString()
    }
}

protocol HomeView: AnyObject {
    func showTask(tasks: [ModelTask])
    func appendItems(task: ModelTask, section: Section)
}

class HomeViewController: UIViewController, UITableViewDelegate, HomeView {
    
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
        configureTableView()
        presenter.viewDidLoad()
        addButton.setTitle("", for: .normal)
        
        let taskLabelLocalize = NSLocalizedString("TaskLabel", comment: "")
        taskLabel.text = taskLabelLocalize
        
        let editButtonLocalize = NSLocalizedString("EditButton", comment: "")
        editButton.setTitle(editButtonLocalize, for: .normal)
    }
    
    @IBAction private func addTaskButton(_ sender: Any) {
        let addVC = AddTaskViewController()
        addVC.delegate = self
        let addPresenter = AddViewPresenterImp(create: addVC, dataStorage: HomeDataStorage())
        addVC.presenter = addPresenter
        navigationController?.pushViewController(addVC, animated: true)
        configureTableView()
        presenter.viewDidLoad()
        addButton.setTitle("", for: .normal)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        dataSource = HomeDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            
            cell.configureCell(viewModel: itemIdentifier)
            return cell
        })
        snapshot = dataSource.snapshot()
    }
    
    func showTask(tasks: [ModelTask]) {
        var snapshot = dataSource.snapshot()
        let sections = [Section.Active, Section.Completed]
        snapshot.appendSections(sections)

        for section in sections {
            let items = tasks.filter { task in
                task.type == section
            }
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func appendItems(task: ModelTask, section: Section) {
        snapshot.appendItems([task], toSection: section)
        dataSource.apply(snapshot)
    }
}
