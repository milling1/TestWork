//
//  HomeViewPresenterTest.swift
//  TaskManagerTests
//
//  Created by user on 12.10.2022.
//

import XCTest
@testable import TaskManager
import CoreData

final class HomeViewPresenterTest: XCTestCase {
    
    var view: MockHomeView!
    var presenter: HomeViewPresenterImp!
    var storage: MockDataStorage!

    override func setUpWithError() throws {
        view = MockHomeView()
        storage = MockDataStorage()
        presenter = HomeViewPresenterImp(view: view, dataStorage: storage)
    }

    override func tearDownWithError() throws {
        view = nil
        storage = nil
        presenter = nil
    }

    func testDeleteTask() throws {
        presenter.deleteTask(ModelTask())
        XCTAssertTrue(storage.isDeleteTaskCalled)
    }
    
    func testUpdateTask() {
        let task = ModelTask(context: StorageProvider.shared.persistentContainer.viewContext)
        presenter.switchTaskState(task)
        XCTAssertNotNil(storage.updateTask(task, title: task.title ?? "", subtitle: task.subtitle, isActive: true))
    }

    func testViewViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertFalse(view.isImageNotHidden)
        XCTAssertTrue(view.isShowTaskCall)
        XCTAssertEqual(view.activeTaskTest, [])
        XCTAssertEqual(view.completedTasktest, [])
    }
}
