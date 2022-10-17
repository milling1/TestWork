//
//  MockAddTaskView.swift
//  TaskManagerTests
//
//  Created by user on 13.10.2022.
//

import XCTest
@testable import TaskManager
import CoreData

final class MockAddTaskView: AddTaskView {
    
    var isConfigTaskCall: Bool = false
    var title: String? = nil
    var subtitle: String? = nil
    
    func configWith(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        isConfigTaskCall = true
    }  
}
