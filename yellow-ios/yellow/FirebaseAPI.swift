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
    // update
    func update(feedContent : FeedContent)  {
        
        let postData = ["postDesc":feedContent.postDesc,
                        "addedByUser":feedContent.addedByUser,
                        "addedByUserURL":feedContent.addedByUserURL,
                        "mediaType":feedContent.mediaType,
                        "mediaURL":feedContent.mediaURL,
                        "love":feedContent.love + 1,
                        "emo": feedContent.emo,
                        "place": feedContent.place,
                        "postDttmInt": feedContent.postDttmInt,
                        "postDttmStr": feedContent.postDttmStr,
                        "lochash":feedContent.lochash] as [String : Any]
        
        storageRef.child(feedContent.key).updateChildValues(postData)
    }
    
     // delete
    func remove(product : FeedContent) {
        
    }
   
}
