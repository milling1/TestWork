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
    func presentModels(testData: [ModelTask])
}

class ViewController: UIViewController, UITableViewDelegate, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    private var arrayDiffable = [ModelTask]()
    
    private var dataSource: DataSourceDiffable!
    var presenter: HomeViewPresenter!
//    var delegate: DataStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifire)
        configureTableView()
        
        addButton.setTitle("", for: .normal)
        
        presenter.viewDidLoad()
    }
    
    private func configureTableView() {
        dataSource = DataSourceDiffable(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            
            switch itemIdentifier.type {
            case .Active:
                cell.configureCell(viewModel: itemIdentifier)
                cell.circleLabel.backgroundColor = .white
                
            case .Completed:
                cell.configureCell(viewModel: itemIdentifier)
                cell.strikethroughText(label: cell.taskLabel)
                
            }
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelTask>()
        let sections = [Section.Active, Section.Completed]
        snapshot.appendSections(sections)
        
        for section in sections {
            let items = DataStorageImp.testData().filter { task in
                task.type == section
            }
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - Presenter Delegate
    
    func presentModels(testData: [ModelTask]) {
        arrayDiffable = testData
    }
}
    
    
    
    
    

