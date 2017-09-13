//
//  StickerCell.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/13/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

class StickerCell: UICollectionViewCell {
    @IBOutlet weak var imv_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInitilization()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitilization()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization()  {
        
    }
}
