//
//  HomeViewPresenter.swift
//  TaskManager
//
//  Created by user on 15.09.2022.
//

import Foundation

protocol HomeViewPresenter {
    func viewDidLoad()
}

class HomeViewPresenterImp: HomeViewPresenter {
    
    var view: HomeView
    
    init (view: HomeView) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.presentModels(testData: DataStorageImp.testData())
    }
}

