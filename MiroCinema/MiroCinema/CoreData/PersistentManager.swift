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

    func fetch(movie: Movie) -> StarredMovie? {
        guard let movieID = movie.ID else { return nil }
        let request: NSFetchRequest<StarredMovie> = StarredMovie.fetchRequest()
        let id = "\(movieID)"
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchAllData() -> [StarredMovie] {
        let request: NSFetchRequest<StarredMovie> = StarredMovie.fetchRequest()
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
            managedObject.setValue(movie.title, forKey: "title")
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            return
        }
    }

    func isInPersistentContainer(movie: Movie) -> Bool {
        let fetchResult = self.fetch(movie: movie)
        return (fetchResult != nil)
    }

    func delete(movie: Movie) {
        guard let starredMovie = self.fetch(movie: movie) else { return }
        self.context.delete(starredMovie)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteAll() {
        let delete = NSBatchDeleteRequest(fetchRequest: StarredMovie.fetchRequest())
        do {
            try self.context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }

}
