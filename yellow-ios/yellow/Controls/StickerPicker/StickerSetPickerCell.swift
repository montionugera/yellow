//
//  StickerSetPickerCell.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/13/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

class StickerSetPickerCell: UICollectionViewCell {
    @IBOutlet weak var imv_icon: UIImageView!
    var hightlightColor : UIColor?
    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInitilization()
    }
    func sharedInitilization()  {
    
    }
    override var isSelected: Bool {
        didSet{
            self.imv_icon.tintColor = isSelected ? hightlightColor : UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        hightlightColor = nil
    }
    
}
