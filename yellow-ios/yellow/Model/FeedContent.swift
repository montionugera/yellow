//
//  PostContent.swift
//  yellow
//
//  Created by montionugera on 8/23/17.
//  Copyright © 2017 23. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct FeedContent {
    
    let key: String
    let postDesc: String
    let addedByUser: String
    let addedByUserName: String
    let addedByUserURL: String
    let emo: String
    let place: String
    let love: Int
    let ref: DatabaseReference?
    var mediaURL: String
    var mediaType: String
    var lochash: String
    var postDttmInt: Double
    var postDttmStr: String
    

    init(postDesc: String, addedByUser: String , addedByUserName: String , addedByUserURL: String, mediaURL: String, emo: String, love: Int, place: String, mediaType: String , lochash: String, postDttmInt: Double , postDttmStr: String, key: String = "") {
        self.key = key
        self.postDesc = postDesc
        self.addedByUser = addedByUser
        self.addedByUserName = addedByUserName
        self.addedByUserURL = addedByUserURL
        self.emo = emo
        self.love = love
        self.place = place
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.lochash = lochash
        self.postDttmInt = postDttmInt
        self.postDttmStr = postDttmStr
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        postDesc = snapshotValue["postDesc"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        if let addedByUserName_ = snapshotValue["addedByUserName"] {
            addedByUserName = addedByUserName_ as! String
        }else{
            addedByUserName = ""
        }
        if let addedByUserURL_ = snapshotValue["addedByUserURL"] {
            addedByUserURL = addedByUserURL_ as! String
        }else{
            addedByUserURL = ""
        }
        emo = snapshotValue["emo"] as! String
        love = snapshotValue["love"] as! Int
        place = snapshotValue["place"] as! String
        mediaURL = snapshotValue["mediaURL"] as! String
        mediaType = snapshotValue["mediaType"] as! String
        lochash = snapshotValue["lochash"] as! String
        postDttmInt = snapshotValue["postDttmInt"] as! Double
        postDttmStr = snapshotValue["postDttmStr"] as! String
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
