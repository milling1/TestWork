//
//  HomeDataSource.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import UIKit

class HomeDataSource: UITableViewDiffableDataSource<Section, ModelTask> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section].localizedString()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let myLabel = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
        myLabel.font = UIFont.boldSystemFont(ofSize: 24)
        myLabel.textColor = .none
        return myLabel.text
    }
}
