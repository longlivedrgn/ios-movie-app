//
//  PersistentManager.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/19.
//

import Foundation
import CoreData
// 그냥 view controller에 들어갈 때, Core data에 있는 지 확인하기!
// 그래서 만약 Core data에 있으면 그냥 star하기!

final class PersistenceManager {

    static var shared: PersistenceManager = PersistenceManager()

    private init() {}

    var persistentContainer: NSPersistentContainer = {
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

    func star(movie: Movie) {
        let entity = NSEntityDescription.entity(forEntityName: "StarredMovie", in: self.context)
        guard let movieID = movie.ID else { return }
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)

            managedObject.setValue(movieID, forKey: "id")
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            return
        }
    }

    func delete(object: NSManagedObject) {
        self.context.delete(object)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) {
        let delete = NSBatchDeleteRequest(fetchRequest: T.fetchRequest())
        do {
            try self.context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }

}
