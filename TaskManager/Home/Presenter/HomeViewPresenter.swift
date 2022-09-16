//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation
import UIKit


protocol HomeViewPresenter {
    
    func viewDidLoad()
}


class HomeViewPresenterImp: HomeViewPresenter {
    
    var view: HomeView
    
    func viewDidLoad() {
        view.presentModels(taskActive:ModelTask.testDataActive(), taskCompleted: ModelTask.testDataCompleted())
    }
    
    init (view: HomeView) {
        self.view = view
    }
    
}

