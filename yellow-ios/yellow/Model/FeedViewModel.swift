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
            print(snapshot.value)
            for item in snapshot.children {
//                let (data,value)  =   FBSnapShotToDictForClassMapping(any: item)
//                let product = Product(id: data.key, dict: value)
//                the.products.append(product)
                
                print(item)
            }
            the.initialDataHasBeenLoaded = true
            the.delegate?.didFinishLoadDataOnInitilization()
        })
        
        firebaseAPI.storageRef.observe(.childChanged, with: {[weak self] (snapshot) in
            guard let the = self else {
                return
            }
            if the.initialDataHasBeenLoaded {
                
//                guard let index = the.products.index(where: { (p) -> Bool in
//                    p.id == snapshot.key
//                }) else {
//                    return
//                }
//                let value = snapshot.value as! Dictionary<String, AnyObject> // 2
//                print("Edit\(value)")
//                let product = Product(id: snapshot.key, dict: value)
//                the.products[index] = product
//                the.delegate?.didFinishUpdate(indexPath: IndexPath(item: index, section: 0), product: product)
            }
            }, withCancel: nil)
        self.observingOnStorageAdd()
    }
    func observingOnStorageAdd()  {
        firebaseAPI.storageRef.observe(.childAdded, with: {[weak self] (snapshot) in
            guard let the = self else {
                return
            }
            print("onAdd:\(snapshot)")
            if the.initialDataHasBeenLoaded {
//                let value = snapshot.value as! Dictionary<String, AnyObject> // 2
//                let product = Product(id: snapshot.key, dict: value)
//                the.products.append(product)
//                the.delegate?.didAppendData(indexPath: IndexPath(item: the.products.count - 1 , section: 0))
            }
        })
    }
    deinit {
        print("deinit In ViewModel")
    }
}
