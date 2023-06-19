//
//  PersistentManager.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/19.
//

import Foundation
import CoreData

final class PersistenceManager {

    static var shared: PersistenceManager = PersistenceManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MiroCinema")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    @discardableResult
    func star(movie: Movie) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "StarredMovie", in: self.context)

        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)

            managedObject.setValue(movie.ID, forKey: "id")
            managedObject.setValue(movie.posterImage, forKey: "posterImage")

            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }

    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }

}
