//
//  ModelTask.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

enum Description {
    case active
    case completed
}

struct ModelTask: Hashable {
    
    let uuid = UUID()
    var title: String
    var description: String?
    var type: Section
    
    
}


    
    






