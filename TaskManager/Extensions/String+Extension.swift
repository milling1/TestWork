//
//  String+Extension.swift
//  TaskManager
//
//  Created by user on 30.09.2022.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
