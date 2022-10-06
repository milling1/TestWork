//
//  HomeDataSource.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import UIKit

class HomeDataSource: UITableViewDiffableDataSource<Section, ModelTask> {
    
    private var dataStorage: HomeDataStorageImp

    init(dataStorage: HomeDataStorageImp,
         tableView: UITableView,
         cellProvider: @escaping UITableViewDiffableDataSource<String, ModelTask>.CellProvider) {
        self.dataStorage = dataStorage
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section].localizedEnum()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let myLabel = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
        myLabel.font = UIFont.boldSystemFont(ofSize: 24)
        myLabel.textColor = .none
        return myLabel.text
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
