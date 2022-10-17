//
//  HomeDataSource.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import UIKit

protocol HomeDataSourceDelegate: AnyObject {
    func didChangeSection(task: ModelTask)
}

class HomeDataSource: UITableViewDiffableDataSource<Section, ModelTask> {
    
    weak var delegate: HomeDataSourceDelegate?

    override init(tableView: UITableView,
         cellProvider: @escaping UITableViewDiffableDataSource<String, ModelTask>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return snapshot().sectionIdentifiers[section].localizedEnum()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let myLabel = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
        myLabel.adjustsFontSizeToFitWidth = true
        myLabel.minimumScaleFactor = 0.01
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let fromIndex = itemIdentifier(for: sourceIndexPath),
              sourceIndexPath != destinationIndexPath else { return }
        
        var snapshot = snapshot()
        snapshot.deleteItems([fromIndex])
        
        if let toIndex = itemIdentifier(for: destinationIndexPath) {
            let isAfter = destinationIndexPath.row > sourceIndexPath.row
            
            if isAfter {
                snapshot.insertItems([fromIndex], afterItem: toIndex)
            } else {
                snapshot.insertItems([fromIndex], beforeItem: toIndex)
            }
        } else {
            snapshot.appendItems([fromIndex], toSection: fromIndex.type ? .Active : .Completed)
        }
        
        apply(snapshot, animatingDifferences: false)
        
        if sourceIndexPath.section != destinationIndexPath.section {
            delegate?.didChangeSection(task: fromIndex)
        }
    }
}
