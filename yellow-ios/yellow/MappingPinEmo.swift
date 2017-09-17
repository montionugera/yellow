//
//  MappingPinEmo.swift
//  yellow
//
//  Created by ekachai limpisoot on 9/10/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit

class MappingPinEmo: NSObject {
    class var shareInstace: MappingPinEmo {
        struct Static {
            static let instance = MappingPinEmo()
        }
        return Static.instance
    }
    
    //MARK:Map Page
    func mappingPin(colorID: String) -> UIImage {
        let color_id = Int(colorID)!
        switch color_id {
        case 1:
            return UIImage(named: "pinLightpink")!
        case 2:
            return UIImage(named: "pinPink")!
        case 3:
            return UIImage(named: "pinRed")!
        case 4:
            return UIImage(named: "pinBlue")!
        case 5:
            return UIImage(named: "pinGreen")!
        case 6:
            return UIImage(named: "pinOrange")!
        case 7:
            return UIImage(named: "pinPurple")!
        default:
            return UIImage(named: "pinGreen")!
        }

    }
    
    
    
    func mappingEmo(colorID: String , emoID: String ) -> UIImage {
        let color_id = Int(colorID)!
        let emo_id = Int(emoID)!
        switch color_id {
        case 1:
            switch emo_id {
            case 1:
                return UIImage(named: "emoSmile")!
            case 2:
                return UIImage(named: "emoJuju")!
            case 3:
                return UIImage(named: "emoSuperlove")!
            case 4:
                return UIImage(named: "emoLove")!
            case 5:
                return UIImage(named: "emoSmile2")!
            default:
                return UIImage(named: "emoSmile")!
            }
            
        case 2:
            switch emo_id {
            case 1:
                return UIImage(named: "emoTired")!
            case 2:
                return UIImage(named: "emoAmaze")!
            case 3:
                return UIImage(named: "emoSleep")!
            default:
                return UIImage(named: "emoTired")!
            }
        case 3:
            switch emo_id {
            case 1:
                return UIImage(named: "emoHurt")!
            case 2:
                return UIImage(named: "emoBoring")!
            case 3:
                return UIImage(named: "emoUnlike")!
            case 4:
                return UIImage(named: "emoAngry")!
            default:
                return UIImage(named: "emoHurt")!
            }
        case 4:
            switch emo_id {
            case 1:
                return UIImage(named: "icoSunshine")!
            case 2:
                return UIImage(named: "icoRain")!
            case 3:
                return UIImage(named: "icoHeavyrain")!
            case 4:
                return UIImage(named: "icoStorm")!
            case 5:
                return UIImage(named: "icoCloudy")!
            case 6:
                return UIImage(named: "icoNight")!
            default:
                return UIImage(named: "icoSunshine")!
            }
        case 5:
            switch emo_id {
            case 1:
                return UIImage(named: "icoSnack")!
            case 2:
                return UIImage(named: "icoCoffee")!
            case 3:
                return UIImage(named: "icoBreakfast")!
            default:
                return UIImage(named: "icoSnack")!
            }
        case 6:
            switch emo_id {
            case 1:
                return UIImage(named: "icoSiren")!
            case 2:
                return UIImage(named: "icoCrash")!
            case 3:
                return UIImage(named: "icoTrafficjam")!
            case 4:
                return UIImage(named: "icoTrafficlight")!
            case 5:
                return UIImage(named: "icoUnderconstruct02")!
            case 6:
                return UIImage(named: "icoUnderconstruct01")!
            default:
                return UIImage(named: "icoSiren")!
            }
        case 7:
            return UIImage(named: "emoSmile")!
        default:
            return UIImage(named: "emoSmile")!
        }
        
    }
    //MARK:Feed List Page
    func mappingTopBar(colorID: String) -> UIImage {
        let color_id = Int(colorID)!
        switch color_id {
        case 1:
            return UIImage(named: "bgPink")!
        case 2:
            return UIImage(named: "bgPinkred")!
        case 3:
            return UIImage(named: "bgRed")!
        case 4:
            return UIImage(named: "bgBlue")!
        case 5:
            return UIImage(named: "bgGreen")!
        case 6:
            return UIImage(named: "bgOrange")!
        case 7:
            return UIImage(named: "bgPurple")!
        default:
            return UIImage(named: "bgYellow")!
        }
    }
    func mappingBGColor(colorID: String) -> UIColor {
        let color_id = Int(colorID)!
        switch color_id {
        case 1:
            return UIColor(red: 255/255, green: 143/255, blue: 180/255, alpha: 1.0)
        case 2:
            return UIColor(red: 255/255, green: 115/255, blue: 129/255, alpha: 1.0)
        case 3:
            return UIColor(red: 238/255, green: 68/255, blue: 94/255, alpha: 1.0)
        case 4:
            return UIColor(red: 138/255, green: 218/255, blue: 237/255, alpha: 1.0)
        case 5:
            return UIColor(red: 92/255, green: 204/255, blue: 145/255, alpha: 1.0)
        case 6:
            return UIColor(red: 251/255, green: 176/255, blue: 59/255, alpha: 1.0)
        case 7:
            return UIColor(red: 144/255, green: 133/255, blue: 224/255, alpha: 1.0)
        default:
            return UIColor(red: 255/255, green: 206/255, blue: 46/255, alpha: 1.0)
        }
        
    }
}
