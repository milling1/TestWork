//
//  DataSourceDiffable.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import UIKit

class DataSourceDiffable: UITableViewDiffableDataSource<Section, ModelTask> {
    
    let sectionArray = ["Active", "Completed"]
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        let headerView = UIView()
        headerView.addSubview(myLabel)
        return headerView
    }
    
    
    

}
