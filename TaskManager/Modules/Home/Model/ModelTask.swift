//
//  ModelTask.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

struct ModelTask: Hashable {
    let uuid = UUID()
    var title: String
    var description: String?
    var type: Section
    var isLastItem: Bool?
}
