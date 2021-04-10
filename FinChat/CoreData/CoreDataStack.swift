//
//  CoreDataStack.swift
//  FinChat
//
//  Created by Артём Мурашко on 01.04.2021.
//

import Foundation
import CoreData

class ModernCoreDataStack {
    private let dataBaseName = "Chat"
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
}
