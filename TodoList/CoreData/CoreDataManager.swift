//
//  CoreDataManager.swift
//  TodoList
//
//  Created by michael on 2018/9/7.
//  Copyright © 2018年 michael. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
  
  let persistenContainer: NSPersistentContainer!

  lazy var backgroundContext: NSManagedObjectContext = {
    return self.persistenContainer.newBackgroundContext()
  }()
  
  //MARK: Init with dependency
  init(container: NSPersistentContainer){
    self.persistenContainer = container
    self.persistenContainer.viewContext.automaticallyMergesChangesFromParent = true
  }
  
  convenience init(){
    //Use the default container for production environment
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{fatalError("Can not get shared AppDelegate")}
    self.init(container: appDelegate.persistentContainer)
  }
  
  func insertData(entityName: String, sort: String, title: String, content: String) {
    guard let item = NSEntityDescription.insertNewObject(forEntityName: entityName, into: backgroundContext) as? TodoItem else{return}
    
    switch entityName {
    case "TodoItem":
      item.sort = sort
      item.title = title
      item.content = content
    default:
      print("Error EntityName")
    }

    save()
  }
  
  
  func retrieve(_ entityName: String, predicate: String?, limit: Int?) -> [NSManagedObject]? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    
    if predicate != nil {
      request.predicate = NSPredicate(format: "sort = %@", predicate!)
    }
    
    if limit != nil {
      request.fetchLimit = limit!
    }
    
    do{
      return try persistenContainer.viewContext.fetch(request) as? [NSManagedObject]
    }catch{
      fatalError("\(error)")
    }
    
    return nil
  }

  func getItem(entityName: String = "TodoItem",predicate: String) -> [NSManagedObject]? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    request.predicate = NSPredicate(format: "content = %@", predicate)

    do{
      return try persistenContainer.viewContext.fetch(request) as? [NSManagedObject]
    }catch{
      fatalError("\(error)")
    }

    return nil
  }
  
  func delete(_ entityName: String, predicate: String) -> Bool{
    if let results = self.getItem(entityName: entityName,predicate: predicate) {
      for result in results {
        persistenContainer.viewContext.delete(result)
      }
      
      save()
      return true
    }
    
    return false
  }
  
  func save() {
    if backgroundContext.hasChanges {
      do {
        try backgroundContext.save()
      } catch {
        print("Save error \(error)")
      }
    }
    
  }
  
  
}
