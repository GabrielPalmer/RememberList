//
//  UserController.swift
//  RememberList
//
//  Created by Gabriel Blaine Palmer on 1/8/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum FilterOption {
    case none
    case adults
    case children
}

class UserController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchUsers(for filter: FilterOption) -> [User] {
        request.returnsObjectsAsFaults = false
        
        switch filter {
        case .none:
            request.predicate = nil
        case .adults:
            request.predicate = NSPredicate(format: "isAdult == true")
        case .children:
            request.predicate = NSPredicate(format: "isAdult == false")
        }
        
        do {
            let result = ((try context.fetch(request)) as! [NSManagedObject]) as! [User]
            return result
        } catch {
            print("failed to fetch users")
            return []
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("failed to update User entity")
        }
    }
    
    @discardableResult func createUser(name: String, isAdult: Bool) -> User {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context) as! User
        
        newUser.name = name
        newUser.isAdult = isAdult
        
        return newUser
    }
    
    func deleteUser(user: User) {
        context.delete(user)
    }
}
