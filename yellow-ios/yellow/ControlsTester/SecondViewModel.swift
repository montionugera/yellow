//
//  SecondViewModel.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/6/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

protocol SecondViewModelDelegate {
    func didFinishLoadData(hasData:Bool)
}
class SecondViewModel : NSObject {
    init(instance : SecondViewModelDelegate) {
        super.init()
        self.delegate = instance
    }
    var delegate : SecondViewModelDelegate?
    var models = [FeedItemModel]()
    func initilization()  {
        mockUpData()
        delegate?.didFinishLoadData(hasData: true)
    }
    var numberOfRecords : Int {
        get{
            return models.count
        }
    }
    func bindCell(cell : FeedCell , at indexPath : IndexPath)  {
        if let mediaURL = models[indexPath.item].mediaURL {
            cell.playerManager.prepare(urlPath: mediaURL )
        }
        cell.lb_title.text = models[indexPath.item].title
        cell.lb_userName.text = models[indexPath.item].userName
    }
    func mockUpData()  {
        //        models.append(FeedItemModel(mediaURL: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"
        //            , userName: "tylerlantern", title: "รถติดจัง"))
        //        models.append(FeedItemModel(mediaURL: "https://ak1.picdn.net/shutterstock/videos/15810721/preview/stock-footage-cybernetic-system-today-game-industry-and-motion-tracking-in-cyberspace-man-with-innovative-specta.mp4"
        //            , userName: "tylerlantern", title: "อิอิ"))
        //        models.append(FeedItemModel(mediaURL: "https://ak2.picdn.net/shutterstock/videos/20914252/preview/stock-footage-group-of-mixed-race-people-having-fun-communicating-and-eating-at-outdoor-family-dinner-shot-on-re.mp4"
        //            , userName: "tylerlantern", title: "ติดจนบ้าไปแล้ว"))
        //        models.append(FeedItemModel(mediaURL: "https://ak6.picdn.net/shutterstock/videos/21556246/preview/stock-footage-delivery-man-loads-his-commercial-van-with-cardboard-boxes-shot-on-red-cinema-camera-in-k-uhd.mp4"
        //            , userName: "tylerlantern", title: "555"))
        //        models.append(FeedItemModel(mediaURL: "https://ak3.picdn.net/shutterstock/videos/19484683/preview/stock-footage-follow-shot-of-businessman-walking-on-streets-of-business-district-shot-on-red-cinema-camera-in-k.mp4"
        //            , userName: "tylerlantern", title: "น่ามคาน"))
        //        models.append(FeedItemModel(mediaURL: "https://ak3.picdn.net/shutterstock/videos/12707153/preview/stock-footage-top-view-diverse-business-people-meeting-at-boardroom-table-discussing-financial-report-using-graphs.mp4"
        //            , userName: "tylerlantern", title: "จุ๊ฟๆๆ"))
        //        models.append(FeedItemModel(mediaURL: "https://ak0.picdn.net/shutterstock/videos/4501190/preview/stock-footage-young-people-with-technology-student-house-accommodation-flat-share-with-teenagers-or-young-adults.mp4"
        //            , userName: "tylerlantern", title: "ไองั่ง"))
        
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        models.append(FeedItemModel(mediaURL: "https://firebasestorage.googleapis.com/v0/b/yellow-2017.appspot.com/o/media%2F8wzRpONLejS88VciOsRoC8aCG0q2%2FC779239A-C4C2-46C1-B133-338B2A459612.mov?alt=media&token=bcb8251a-4704-4001-bf79-02c76aec509c"
            , userName: "tylerlantern", title: "ไองั่ง"))
        
        
    }
    
}
