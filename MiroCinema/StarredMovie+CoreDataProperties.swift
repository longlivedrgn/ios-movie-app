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
        let request = NSFetchRequest<StarredMovie>(entityName: "StarredMovie")
        return request
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String

}
