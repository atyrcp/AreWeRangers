//
//  Result.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/17.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    var results: [CellData]
}

struct CellData: Codable {
    var type: String
    
    var id: String?
    var name: String?
    var position: String?
    var expertise: [String]?
    var avatar: String?
    var url: String?
}
