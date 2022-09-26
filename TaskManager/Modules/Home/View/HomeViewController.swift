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
}

protocol HomeView: AnyObject {
    func showTask(tasks: [ModelTask])
}

class HomeViewController: UIViewController, UITableViewDelegate, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    private var dataSource: HomeDataSource!
    var presenter: HomeViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureTableView()
        presenter.viewDidLoad()
        addButton.setTitle("", for: .normal)
    }
    
    @IBAction private func addTaskButton(_ sender: Any) {
       
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        dataSource = HomeDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}

            switch itemIdentifier.type {
            case .Active:
                cell.configureCell(viewModel: itemIdentifier)
                
            case .Completed:
                cell.configureCell(viewModel: itemIdentifier)
            }

            return cell
        })
    }
    
    func showTask(tasks: [ModelTask]) {
        var snapshot = dataSource.snapshot()
        let sections = [Section.Active, Section.Completed]
        snapshot.appendSections(sections)

        for section in sections {
            var items = tasks.filter { task in
                task.type == section
            }
            var tasks = [ModelTask]()
            
            for item in items {
                var task = item
                if item == items.last {
                    task.isLastItem = true
                }
                tasks.append(task)
            }
            snapshot.appendItems(tasks, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
