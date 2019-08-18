//
//  BannerCell.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell, NibNameProtocol {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    func setOutlook(from cellData: CellData) {
        bannerImageView.image = UIImage.contentOfURL(url: cellData.url ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
