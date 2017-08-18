//
//  Utility+AkeKit.swift
//  airmosphere
//
//  Created by ekachai limpisoot on 4/30/16.
//  Copyright © 2016 com.airasia. All rights reserved.
//

import Foundation

public class Utility_AkeKit : NSObject {
    
    public func DictionarytoData(dic:AnyObject?) -> NSData?
    {
        if dic == nil {return nil}
        else {
            return NSKeyedArchiver.archivedData(withRootObject: dic!) as NSData?
        }
    }
    public func DatatoDictionary(data:NSData?) -> NSDictionary?
    {
        if data == nil {return nil}
        else {
            return NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? NSDictionary
        }
    }
    
    public func ConvertIntToDecimalFormat(value: Int) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: value))!
    }
    
    public func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
   
    
}

//extension String {
//    func getLineAtIndex(index: Int) -> String? {
//        let lines = self.componentsSeparatedByString("\n")
//        if lines.count > index {
//            return lines[index]
//        }
//        else {
//            return nil
//        }
//    }
//}


//func getLineOfText(lineIndex: Int, text: String) -> String?{
//    let line = text.componentsSeparatedByString("\n")
//    if line.count > lineIndex {
//        return line[lineIndex]
//    }
//    else {
//        return nil
//    }
//}
