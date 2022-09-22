//
//  ViewController.swift
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

class ViewController: UIViewController, UITableViewDelegate, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    private var dataSource: DataSourceDiffable!
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
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifire)
        
        dataSource = DataSourceDiffable(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            
            switch itemIdentifier.type {
            case .Active:
                cell.configureCell(viewModel: itemIdentifier)
                cell.circleLabel.backgroundColor = .white
                
            case .Completed:
                cell.configureCell(viewModel: itemIdentifier)
                cell.strikethroughText()
                
            }
            return cell
        })
    }
    
    func showTask (tasks: [ModelTask]) {
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
}
