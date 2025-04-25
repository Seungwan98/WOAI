//
//  CoreDataManager.swift
//  WOAI
//
//  Created by 양승완 on 4/25/25.
//
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskModel") // .xcdatamodeld 이름
        // Test용
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
