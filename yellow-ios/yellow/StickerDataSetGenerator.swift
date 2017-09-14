//
//  StickerDataSetGenerator.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/12/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
class StickerDataSetGenerator: NSObject {
    static func getDataSet() -> [[StickerModel]]  {
        var containerSet = [[StickerModel]] ()
        var firstSet : [StickerModel] = []
        firstSet.append(StickerModel(id: 1, iconName: "emoSmile", containerSetId: 1))
        firstSet.append(StickerModel(id: 2, iconName: "emoJuju", containerSetId: 1))
        firstSet.append(StickerModel(id: 3, iconName: "emoSuperlove", containerSetId: 1))
        firstSet.append(StickerModel(id: 4, iconName: "emoLove", containerSetId: 1))
        firstSet.append(StickerModel(id: 5, iconName: "emoSmile2", containerSetId: 1))
        containerSet.append(firstSet)
        
        var secondSet : [StickerModel] = []
        secondSet.append(StickerModel(id: 1, iconName: "emoTired", containerSetId: 2))
        secondSet.append(StickerModel(id: 2, iconName: "emoAmaze", containerSetId: 2))
        secondSet.append(StickerModel(id: 3, iconName: "emoSleep", containerSetId: 2))
        secondSet.append(StickerModel(id: 4, iconName: "emoTired", containerSetId: 2))
        containerSet.append(secondSet)
        
        var thirdSet : [StickerModel] = []
        thirdSet.append(StickerModel(id: 1, iconName: "emoHurt", containerSetId: 3))
        thirdSet.append(StickerModel(id: 2, iconName: "emoBoring", containerSetId: 3))
        thirdSet.append(StickerModel(id: 3, iconName: "emoUnlike", containerSetId: 3))
        thirdSet.append(StickerModel(id: 4, iconName: "emoAngry", containerSetId: 3))
        thirdSet.append(StickerModel(id: 5, iconName: "emoHurt", containerSetId: 3))
        containerSet.append(thirdSet)
        
        var fourthSet : [StickerModel] = []
        fourthSet.append(StickerModel(id: 1, iconName: "icoSunshine", containerSetId: 3))
        fourthSet.append(StickerModel(id: 2, iconName: "icoRain", containerSetId: 3))
        fourthSet.append(StickerModel(id: 3, iconName: "icoHeavyrain", containerSetId: 3))
        fourthSet.append(StickerModel(id: 4, iconName: "icoStorm", containerSetId: 3))
        fourthSet.append(StickerModel(id: 5, iconName: "icoCloudy", containerSetId: 3))
        fourthSet.append(StickerModel(id: 6, iconName: "icoNight", containerSetId: 3))
        containerSet.append(fourthSet)
        
        var fifthSet : [StickerModel] = []
        fifthSet.append(StickerModel(id: 1, iconName: "icoSnack", containerSetId: 4))
        fifthSet.append(StickerModel(id: 2, iconName: "icoCoffee", containerSetId: 4))
        fifthSet.append(StickerModel(id: 3, iconName: "icoBreakfast", containerSetId: 4))
        containerSet.append(fifthSet)
        
        var sixthSet : [StickerModel] = []
        sixthSet.append(StickerModel(id: 1, iconName: "icoSiren", containerSetId: 5))
        sixthSet.append(StickerModel(id: 2, iconName: "icoCrash", containerSetId: 5))
        sixthSet.append(StickerModel(id: 3, iconName: "icoTrafficjam", containerSetId: 5))
        sixthSet.append(StickerModel(id: 4, iconName: "icoTrafficlight", containerSetId: 5))
        sixthSet.append(StickerModel(id: 5, iconName: "icoUnderconstruct02", containerSetId: 5))
        sixthSet.append(StickerModel(id: 6, iconName: "icoUnderconstruct01", containerSetId: 5))
        containerSet.append(sixthSet)
        return containerSet
    }
    static func getPickerIcons() -> [StickerSetPickerModel] {
        var models = [StickerSetPickerModel]()
        models.append(StickerSetPickerModel(iconName: "emoSmile", highLightColor: UIColor(red: 1, green: 143/255, blue: 180/255, alpha: 1 )))
        models.append(StickerSetPickerModel(iconName: "emoTired", highLightColor: UIColor(red: 1, green: 155/255, blue: 129/255, alpha: 1 )))
        models.append(StickerSetPickerModel(iconName: "emoHurt", highLightColor: UIColor(red: 238/255 , green: 68/255, blue: 94/255, alpha: 1 )))
        models.append(StickerSetPickerModel(iconName: "icoSunshine", highLightColor: UIColor(red: 138/255, green: 218/255, blue: 237/255, alpha: 1 )))
        models.append(StickerSetPickerModel(iconName: "icoSnack"
            , highLightColor: UIColor(red: 94/255, green: 204/255, blue: 143/255, alpha: 1 )))
        models.append(StickerSetPickerModel(iconName: "icoSiren"
            , highLightColor: UIColor(red: 251/255, green: 176/255, blue: 59/255, alpha: 1 )))
        return models
    }
}
