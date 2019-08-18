//
//  EmployeeCell.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class EmployeeCell: UICollectionViewCell, NibNameProtocol {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var expertiseLabel: UILabel!
    
    func setOutlook(from cellData: CellData, in width: CGFloat) {
        avatarImageView.image = UIImage.contentOfURL(url: cellData.avatar ?? "")
        
        nameLabel.text = cellData.name ?? ""
        positionLabel.text = cellData.position ?? ""
        expertiseLabel.text = cellData.expertise?.allText() ?? ""
        
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.cornerRadius = width / 20 * 3
        avatarImageView.clipsToBounds = true

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
