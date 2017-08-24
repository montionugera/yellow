//
//  UserModel.swift
//
//  Created by ekachai limpisoot on 5/1/17.
//  Copyright © 2017 com.airasia. All rights reserved.
//

import Foundation
import Haneke
class UserModel: NSObject{
    let cache = Shared.dataCache
    let dataBaseKey = "UserModel"
    var raw_info :[String:AnyObject]!
    
    var user_id : NSNumber?
    var user_email : String?
    var user_name : String?
    var user_profile : String?
    
    class var currentUser: UserModel {
        struct Static {
            static let instance = UserModel()
        }
        Static.instance.getAsDatabase(completionHandler: {})
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "delFlag"  {
           // delFlag = value as? Bool
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    func updateFromProp(dic:[String: AnyObject]){
        setValuesForKeys(dic)
        self.raw_info = dic;
    }
    
    func saveAsDatabase(dict:[String: AnyObject]){
        let ditoData : NSData = Utility_AkeKit().DictionarytoData(dic: dict as AnyObject?)!
        self.cache.set(value: ditoData as Data, key: dataBaseKey)
        updateFromProp(dic: dict)
    }
    func getAsDatabase(completionHandler:@escaping () -> ()){
            // do some task
        let result = self.cache.fetch(key: self.dataBaseKey).onSuccess { data in
            let dicfromData:NSDictionary? = Utility_AkeKit().DatatoDictionary(data: data as NSData?)
            self.updateFromProp(dic: dicfromData! as! [String : AnyObject])
            completionHandler()
        }
        
        _ = self.cache.fetch(key: self.dataBaseKey).onFailure { data in
            completionHandler()
        }
        
        print(result)

    }
    
    func isLogined() -> Bool{
        if !(UserModel.currentUser.isEqual(nil)) &&
            (self.user_id != nil && (String(describing: self.user_id).characters.count) > 0){
            return true
        }
        return false
    }
    
    
    func setAsLogOut(){
        self.cache.remove(key: self.dataBaseKey)
        self.user_id = nil
        self.user_email = nil
        self.user_name = nil
        self.user_profile = nil
        
        self.raw_info = nil

    }
    
    
}
