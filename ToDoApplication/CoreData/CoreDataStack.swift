//
//  CoreDataStack.swift
//  ToDoApplication
//
//  Created by Tushar on 27/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var conatiner: NSPersistentContainer {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores { (descripation, error) in
            if error != nil {
                print(error)
                return
            }
        }
        return container
    }
    
    var manageContext: NSManagedObjectContext {
        return conatiner.viewContext
    }
}
