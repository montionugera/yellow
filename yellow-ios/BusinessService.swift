//
//  BusinessService.swift
//  yellow
//
//  Created by montionugera on 8/23/17.
//  Copyright © 2017 23. All rights reserved.
//
class ServicePool {
    
    // MARK: - Shared Instance
    var serviceIdMapToBusinessService  = [:] as [String:BusinessService]
    static let sharedInstance = ServicePool()
    func getPostingService() -> [BusinessService] {
        return []
    }
}
import UIKit

class BusinessService: NSObject {
    var serviceType = 0
    func runCustomServiceOnPool(customServiceBody: (() -> (AnyObject?,AnyObject?))!, completion: ((AnyObject?,AnyObject?) -> Void)?){
        let resp: AnyObject?
        let error:AnyObject?
        (resp,error) = customServiceBody()
        if let _completion = completion {
            _completion(resp,error)
        }
        
    }
}
