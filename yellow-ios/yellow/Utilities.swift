//
//  Utilities.swift
//  FirebaseIntroduction
//
//  Created by Nattapong Unaregul on 8/11/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
import Firebase
func FBSnapShotToDictForClassMapping( any :Any ) -> (data : DataSnapshot,value : [String:AnyObject]) {
    let data = any as! DataSnapshot
    let value = data.value as! [String:AnyObject]
    return (data,value)
}
