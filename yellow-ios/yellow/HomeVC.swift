//
//  HomeVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
//import CoreLocation

class HomeVC: UIViewController,UITabBarControllerDelegate  {
    let tabbarTC = CustomUITabBarController()
    let mapVC = MapVC()
    let postVC = PostDummyVC()
    let myProfileVC = MyProfileVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbarTC.delegate = self
        self.tabbarTC.view.frame = self.view.frame
        self.view.addSubview(self.tabbarTC.view)
        self.setTabbar()
        /*
        // Do any additional setup after loading the view.
        if let (lat, lon) = Geohash.decode(hash: "u4pruydqqvj") {
            print(lat)
            print(lon)
            // lat.min == 57.649109959602356
            // lat.max == 57.649111300706863
            // lon.min == 10.407439023256302
            // lon.max == 10.407440364360809
        }
        
        let hashloc = Geohash.encode(latitude: 57.64911063015461, longitude: 10.40743969380855, length: 10)
        
        print("hash loc : "+hashloc)
        // s == "u4pruydqqv"
        
        let dd = CLLocationCoordinate2D(geohash: "u4pruydqqvj")
        print(dd.latitude)
        print(dd.longitude)
//        if let l = CLLocationCoordinate2D(geohash: "u4pruydqqvj") {
//            print(l)
//            // l.latitude == 57.64911063015461
//            // l.longitude == 10.407439693808556
//        }
        
        let l = CLLocationCoordinate2DMake(57.64911063015461, 10.40743969380855)
        let s = l.geohash(length: 10)
        // s == u4pruydqqv
        
        
        */
        
    }
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        if( viewController == postVC){
            let realPostVC = PostVC()
            self.tabbarTC.present(realPostVC, animated: true, completion: nil)
           return false
        }
        return true
    }
    
    func setTabbar(){
        let feedListVC = FeedListVC(nibName: "FeedListVC", bundle: nil)
        
        let pulleyController = PulleyViewController(contentViewController: self.mapVC, drawerViewController: feedListVC)
        pulleyController.drawerCornerRadius = 0
        
        let homeTabbarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icoHome"), selectedImage: UIImage(named: "icoHome"))
        homeTabbarItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
        pulleyController.tabBarItem = homeTabbarItem
        
        let postTabbarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "btNewPost"), selectedImage: UIImage(named: "btNewPost"))
        postTabbarItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
        self.postVC.tabBarItem = postTabbarItem
        
        
        let profileTabbarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icoProfile"), selectedImage: UIImage(named: "icoProfile"))
        profileTabbarItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
        self.myProfileVC.tabBarItem = profileTabbarItem
        self.myProfileVC.main_vct = self
        
        let controllers = [pulleyController,self.postVC,self.myProfileVC]
        self.tabbarTC.viewControllers = controllers
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        self.goLogin()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.Alertlocation()
    }
    
    func goLogin(){
        if UserModel.currentUser.isLogined() == false {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            loginVC.mapvc_main = self.mapVC
            self.present(loginVC,animated: true,completion: nil)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
