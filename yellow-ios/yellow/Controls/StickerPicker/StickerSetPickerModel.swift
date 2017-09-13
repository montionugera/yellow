//
//  StickerSetPickerModel.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/13/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

class StickerSetPickerModel: NSObject {
    var iconName : String!
    var highLightColor : UIColor?
    
    init(iconName : String , highLightColor : UIColor?) {
        super.init()
        self.iconName = iconName
        self.highLightColor = highLightColor
    }
    var iconImage : UIImage? {
        get{
            return UIImage(named: iconName)
        }
    }
}
