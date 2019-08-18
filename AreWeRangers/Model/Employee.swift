//
//  Employee.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/17.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

struct Employee: TypeReferrenceProtocol {
    var type: String = "employee"
    
    var id: String
    var name: String
    var position: String
    var expertise: [String]
    var avatar: String
}
