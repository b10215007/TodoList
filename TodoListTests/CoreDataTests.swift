//
//  CoreDataTests.swift
//  TodoListTests
//
//  Created by michael on 2018/9/9.
//  Copyright © 2018年 michael. All rights reserved.
//

import CoreData
import XCTest

@testable import TodoList

class CoreDataTests: XCTestCase {

  var sut: CoreDataManager!

  //設定setUp, tearDown 讓每個test case 都是嶄新的開始
  override func setUp() {
    super.setUp()

    initStubs()
    sut = CoreDataManager(container: mockPersistantContainer)

    //Listen to the change in context
    NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
  }

  override func tearDown() {
    NotificationCenter.default.removeObserver(self)
    flushData()

    super.tearDown()
  }

  func test_create_todo(){
    sut.insertData(entityName: "TodoItem", sort: "早上", title: "起床", content: "刷刷牙")
    let items = sut.retrieve("TodoItem", predicate: nil, limit: nil)

    XCTAssertEqual(items?.count, 6)
  }

  func test_fetch_all_todo(){
    let result = sut.retrieve("TodoItem", predicate: nil, limit: nil)

    XCTAssertEqual(result?.count, 5)
  }

  func test_remove_todo(){
    //When remove a item
    XCTAssertTrue(sut.delete("TodoItem", predicate: nil))
  }

  func test_save(){
    _ = expectationForSaveNotification()
    _ = sut.insertData(entityName: "TodoItem", sort: "早上", title: "起床", content: "刷刷牙")

    expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, handler: nil)
    sut.save()

    waitForExpectations(timeout: 1.0, handler: nil)
  }


  //MARK: mock in-memory persistant store
  lazy var managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
    return managedObjectModel
  }()

  lazy var mockPersistantContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TodoList", managedObjectModel: managedObjectModel)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false //Make it simpler in test env

    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
      //check if the data store in memory
      precondition(description.type == NSInMemoryStoreType)

      //check if creating container is wrong
      if error != nil {
        fatalError("Create an in-mem coordinator failed \(error)")
      }
    }

    return container
  }()


  //MARK: Convinient function for Notification
  var saveNotificationCompleteHandler: ((Notification) -> ())?

  func expectationForSaveNotification() -> XCTestExpectation {
    let expect = expectation(description: "Context Saved")
    waitForSavedNotification{ (notification) in
      expect.fulfill()
    }
    return expect
  }

  func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
    saveNotificationCompleteHandler = completeHandler
  }


  func contextSaved( notification: Notification ){
    print("\(notification)")
    saveNotificationCompleteHandler? (notification)
  }

}


//Create some fakes
extension CoreDataTests {

  func initStubs(){

    func insertTodoItem(title: String , sort: String, content: String) -> TodoItem? {
      let obj = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: mockPersistantContainer.viewContext)

      obj.setValue("家事", forKey: "sort")
      obj.setValue("123", forKey: "title")
      obj.setValue("456", forKey: "content")

      return obj as? TodoItem
    }


    _ = insertTodoItem(title: "1", sort: "放假", content: "睡覺")
    _ = insertTodoItem(title: "2", sort: "放假", content: "發呆")
    _ = insertTodoItem(title: "3", sort: "放假", content: "看電視")
    _ = insertTodoItem(title: "4", sort: "放假", content: "打電動")
    _ = insertTodoItem(title: "5", sort: "放假", content: "耍廢")

    do{
      try mockPersistantContainer.viewContext.save()
    }catch {
      print("Creat fake error \(error)")
    }
  }

  func flushData(){

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
    let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)

    for case let obj as NSManagedObject in objs {
      mockPersistantContainer.viewContext.delete(obj)
    }

    try! mockPersistantContainer.viewContext.save()
  }



  func numberOfItemsInPersistantStore() -> Int {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoItem")
    let results = try! mockPersistantContainer.viewContext.fetch(request)

    return results.count
  }

}
