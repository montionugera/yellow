//
//  StickerModel.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/12/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
class StickerModel : NSObject,NSCopying {
    var id : Int!
    var iconName : String!
    var containerSetId : Int!
    init(id : Int, iconName : String , containerSetId : Int) {
        super.init()
        self.id = id
        self.iconName = iconName
        self.containerSetId = containerSetId
    }
    
    var iconImage : UIImage? {
        get{
            return UIImage(named: iconName)
        }
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = StickerModel(id: id, iconName: iconName, containerSetId: containerSetId)
        return copy
    }
    func clone() ->  StickerModel{
        return self.copy() as! StickerModel
    }
}
