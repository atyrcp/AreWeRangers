//
//  SavedRangers+CoreDataProperties.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/18.
//  Copyright © 2019 z. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedRangers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRangers> {
        return NSFetchRequest<SavedRangers>(entityName: "SavedRangers")
    }

    @NSManaged public var type: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var position: String?
    @NSManaged public var expertise: [String]?
    @NSManaged public var avatar: String?
    @NSManaged public var url: String?

}
