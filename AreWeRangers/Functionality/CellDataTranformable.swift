//
//  CellDataTranformable.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/18.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

protocol CellDataTransformable {
    var type: String? {get}
    var id: String? {get}
    var name: String? {get}
    var position: String? {get}
    var expertise: [String]? {get}
    var avatar: String? {get}
    var url: String? {get}
    func transforToCellData() -> CellData
}

extension CellDataTransformable {
    func transforToCellData() -> CellData {
        let celldata = CellData(type: type!, id: id, name: name, position: position, expertise: expertise, avatar: avatar, url: url)
        return celldata
    }
}
