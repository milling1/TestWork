//
//  LocalizableString.swift
//  TaskManager
//
//  Created by user on 29.09.2022.
//

import Foundation

struct LocalizableString {
    
    enum Home {
        static let taskLabel = NSLocalizedString("home.taskLabel", comment: "")
        static let editButton = NSLocalizedString("home.editButton", comment: "")
        static let activeSection = NSLocalizedString("home.activeSection", comment: "")
        static let completedSection = NSLocalizedString("home.completedSection", comment: "")
    }
}
