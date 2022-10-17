//
//  AddViewPresenterTest.swift
//  TaskManagerTests
//
//  Created by user on 13.10.2022.
//

import XCTest
@testable import TaskManager
import CoreData

final class AddViewPresenterTest: XCTestCase {
    
    var view: MockAddTaskView!
    var storage: MockDataStorage!
    var presenter: AddViewPresenterImp!
    
    override func setUpWithError() throws {
        view = MockAddTaskView()
        storage = MockDataStorage()
        presenter = AddViewPresenterImp(view: view, dataStorage: storage, task: ModelTask())
    }

    override func tearDownWithError() throws {
        view = nil
        storage = nil
        presenter = nil
    }
    
    func testPresentTask() {
        let task = ModelTask(context: StorageProvider.shared.persistentContainer.viewContext)
        task.title = "Title"
        task.subtitle = "Subtitle"
        presenter.task = task
        presenter.present()
        XCTAssertEqual(view.title, task.title)
        XCTAssertEqual(view.subtitle, task.subtitle)
        XCTAssertTrue(view.isConfigTaskCall)
    }
    
    func testPresentTaskNil() {
        let task = ModelTask(context: StorageProvider.shared.persistentContainer.viewContext)
        presenter.task = task
        presenter.present()
        XCTAssertEqual(view.title, "")
        XCTAssertEqual(view.subtitle, "")
        XCTAssertTrue(view.isConfigTaskCall)
    }
}
