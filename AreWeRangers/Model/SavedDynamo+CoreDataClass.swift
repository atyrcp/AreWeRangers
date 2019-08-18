//
//  SavedDynamo+CoreDataClass.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/18.
//  Copyright © 2019 z. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SavedDynamo)
public class SavedDynamo: NSManagedObject, CellDataTransformable {
    
    func setProperty(with cellData: CellData) {
        self.type = cellData.type
        self.id = cellData.id
        self.name = cellData.name
        self.position = cellData.position
        self.expertise = cellData.expertise
        self.avatar = cellData.avatar
        self.url = cellData.url
    }
}
