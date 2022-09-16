//
//  ViewController.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

enum Section: Int {
    case active = 0
    case completed = 1
}

protocol HomeView: AnyObject {
    func presentModels(taskActive: [ModelTask], taskCompleted: [ModelTask])
    
}

class ViewController: UIViewController, UITableViewDelegate, HomeView {
    
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var taskLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIButton!
    
    
    private var arrayDiffableActive = [ModelTask]()
    private var arrayDiffableCompleted = [ModelTask]()
    
    private var dataSource: DataSourceDiffable!
    var presenter: HomeViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TaskTableViewCell.self))
        configureTableView()
        
        addButton.setTitle("", for: .normal)
        
        presenter.viewDidLoad()
    }
    
    private func configureTableView() {
        dataSource = DataSourceDiffable(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskTableViewCell.self), for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
            
            switch indexPath.section {
            case Section.active.rawValue:
                cell.taskLabel.text = self.arrayDiffableActive[indexPath.item].task
                cell.circleLabel.backgroundColor = .white
                
            case Section.completed.rawValue:
                cell.taskLabel.text = self.arrayDiffableCompleted[indexPath.item].task
                cell.strikethroughText(label: cell.taskLabel)
            default:
                return UITableViewCell()
            }
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelTask>()
        snapshot.appendSections([Section.active, Section.completed])
       
        snapshot.appendItems(ModelTask.testDataActive(), toSection: Section.active)
        snapshot.appendItems(ModelTask.testDataCompleted(), toSection: Section.completed)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    //MARK: - Presenter Delegate
    
    func presentModels(taskActive: [ModelTask], taskCompleted: [ModelTask]) {
        arrayDiffableActive = taskActive
        arrayDiffableCompleted = taskCompleted
    }
}
    
    
    
    
    

