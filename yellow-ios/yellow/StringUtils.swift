//
//  StringUtils.swift
//  yellow
//
//  Created by montionugera on 8/28/17.
//  Copyright © 2017 23. All rights reserved.
//

import Foundation
let dateFormatter = DateFormatter()

func getStandardAppDateString(dttm: Date)->String{
    dateFormatter.dateFormat = "EEEE, h a"
    return dateFormatter.string(from: dttm)
}
