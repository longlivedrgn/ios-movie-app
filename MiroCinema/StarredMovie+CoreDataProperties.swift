//
//  StarredMovie+CoreDataProperties.swift
//  
//
//  Created by 김용재 on 2023/06/19.
//
//

import Foundation
import CoreData


extension StarredMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarredMovie> {
        return NSFetchRequest<StarredMovie>(entityName: "StarredMovie")
    }

    @NSManaged public var id: Int16
    @NSManaged public var posterImage: Data?

}
