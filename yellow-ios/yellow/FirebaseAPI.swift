//
//  FirebaseAPI.swift
//  FirebaseIntroduction
//
//  Created by Ekachai Limpisoot on 8/30/17.
//  Copyright © 2017 Ekachai Limpisoot. All rights reserved.
//

import UIKit
import Firebase
class FirebaseAPI: NSObject {
    
    var storageRef: DatabaseReference = Database.database().reference().child("posts")
    // add
    // update
    // delete
}
