//
//  Extensions.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/17.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func contentOfURL(url: String) -> UIImage? {
        guard let url = URL(string: url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {return nil}
        return image
    }
}

extension Array {
    func allText() -> String? {
        var text = ""
        var count = 0
        for element in self {
            if element is LosslessStringConvertible {
                count += 1
                let stringValue = String(describing: element)
                if count == self.count {
                    text.append(stringValue)
                } else {
                    text.append(stringValue + ", ")
                }
            } else {
                return nil
            }
        }
        return text
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return text!.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
    }
}
