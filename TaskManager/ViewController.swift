//
//  ViewController.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let sectionArray = ["Active", "Completed"]
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TaskTableViewCell.self))
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: TaskTableViewCell.self), for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            cell.circleImageView.backgroundColor = .clear
        case 1:
            return cell
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    
    //MARK: - Incerc sa fac denumirea in la sectie mai pronuntata. Nu se primeste
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
    }
}
