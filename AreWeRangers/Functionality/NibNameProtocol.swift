//
//  NibNameProtocol.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

protocol NibNameProtocol {
    
}

extension NibNameProtocol where Self: UIView {
    static func nibName() -> String {
        return String(describing: Self.self)
    }
}
