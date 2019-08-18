//
//  TitleView.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class TitleView: UIView, NibNameProtocol {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rangersLabel: UILabel!
    @IBOutlet weak var elasticLabel: UILabel!
    @IBOutlet weak var dynamoLabel: UILabel!
    @IBOutlet weak var dummyLabel: UILabel!
    @IBOutlet weak var currentSelectionView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    
    private func customSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle.main.loadNibNamed(TitleView.nibName(), owner: self, options: nil)
        addSubview(contentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSetup()
    }
    
    
}
