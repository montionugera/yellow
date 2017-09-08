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
                the.feedContents.append(feedContent)
                
                print(item)
            }
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
                the.delegate?.didAppendData(indexPath: IndexPath(item: the.feedContents.count - 1 , section: 0))
            }
        })
    }
    deinit {
        print("deinit In ViewModel")
    }
}
