//
//  PostContent.swift
//  yellow
//
//  Created by montionugera on 8/23/17.
//  Copyright © 2017 23. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct PostContent {
    
    let key: String
    let postDesc: String
    let addedByUser: String
    let ref: DatabaseReference?
    var mediaURL: String
    var mediaType: String
    
    init(postDesc: String, addedByUser: String, mediaURL: String, mediaType: String, key: String = "") {
        self.key = key
        self.postDesc = postDesc
        self.addedByUser = addedByUser
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        postDesc = snapshotValue["postDesc"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        mediaURL = snapshotValue["mediaURL"] as! String
        mediaType = snapshotValue["mediaType"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "postDesc": postDesc,
            "addedByUser": addedByUser,
            "mediaType": mediaType,
            "mediaURL": mediaURL
        ]
    }
    
}
