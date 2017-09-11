//
//  FeedViewModel.swift
//  FirebaseIntroduction
//
//  Created by Ekachai Limpisoot on 8/30/17.
//  Copyright © 2017 Ekachai Limpisoot. All rights reserved.
//
import UIKit
import FirebaseDatabase

protocol FeedViewModelDelegate : class {
    func didAppendData(indexPath : IndexPath)
    func didFinishLoadDataOnInitilization()
    func didRemoveData(indexPath : IndexPath)
    func didFinishUpdate(indexPath : IndexPath , product : FeedContent )
}
class FeedViewModel: NSObject {
    var firebaseAPI : FirebaseAPI!
    var feedContents : [FeedContent] = [FeedContent]()
    weak var delegate : FeedViewModelDelegate?
    fileprivate var initialDataHasBeenLoaded : Bool = false
    override init() {
        super.init()
    }
    func initilization()  {
        firebaseAPI = FirebaseAPI()
        firebaseAPI.storageRef.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            guard let the = self else {
                return
            }
            for item in snapshot.children {
                //                let (data,value)  =   FBSnapShotToDictForClassMapping(any: item)
                
                let feedContent = FeedContent(snapshot:item as! DataSnapshot)
//                if(self?.timeAgo24Hr( Date(timeIntervalSince1970: TimeInterval(feedContent.postDttmInt)) , currentDate: Date()) == false){
                    the.feedContents.append(feedContent)
//                }
//                print(item)
            }
            
            // sort date time
            the.feedContents.sort { $0.postDttmInt > $1.postDttmInt }
            
            
            the.initialDataHasBeenLoaded = true
            the.delegate?.didFinishLoadDataOnInitilization()
        })
        
        self.observingOnStorageAdd()
    }
    func observingOnStorageAdd()  {
        firebaseAPI.storageRef.observe(.childAdded, with: {[weak self] (snapshot) in
            guard let the = self else {
                return
            }
            if the.initialDataHasBeenLoaded {
                
                print("onAdd:\(snapshot)")
                let feedContent = FeedContent(snapshot:snapshot)
                the.feedContents.append(feedContent)
                // sort date time
                the.feedContents.sort { $0.postDttmInt > $1.postDttmInt }
                
                the.delegate?.didAppendData(indexPath: IndexPath(item: the.feedContents.count - 1 , section: 0))
            }
        })
    }
    deinit {
        print("deinit In ViewModel")
    }
    
    func timeAgo24Hr(_ date:Date,currentDate:Date) -> Bool {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return true
        } else if (components.year! >= 1){
            return true
        } else if (components.month! >= 2) {
            return true
        } else if (components.month! >= 1){
            return true
        } else if (components.weekOfYear! >= 2) {
            return true
        } else if (components.weekOfYear! >= 1){
            return true
        } else if (components.day! >= 2) {
            return true
        } else if (components.day! >= 1){
            return true
        } else if (components.hour! >= 2) {
            return false
        } else if (components.hour! >= 1){
            return false
        } else if (components.minute! >= 2) {
            return false
        } else if (components.minute! >= 1){
            return false
        } else if (components.second! >= 3) {
            return false
        } else {
            return false
        }
        
    }
}
