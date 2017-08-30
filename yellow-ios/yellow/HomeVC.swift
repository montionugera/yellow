//
//  HomeVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import Pulley
class HomeVC: UIViewController,UITabBarControllerDelegate  {

    let tabbarTC = UITabBarController()
    let mapVC = MapVC()
    let postVC = PostVC()
    let myProfileVC = MyProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabbarTC.delegate = self
        self.tabbarTC.view.frame = self.view.frame
        self.view.addSubview(self.tabbarTC.view)
        self.setTabbar()
        
        
        // Do any additional setup after loading the view.
        if let (lat, lon) = Geohash.decode(hash: "u4pruydqqvj") {
            print(lat)
            print(lon)
            // lat.min == 57.649109959602356
            // lat.max == 57.649111300706863
            // lon.min == 10.407439023256302
            // lon.max == 10.407440364360809
        }
        let s = Geohash.encode(latitude: 57.64911063015461, longitude: 10.40743969380855, length: 10)
        // s == "u4pruydqqv"

        
    }
    
    func setTabbar(){
        //self.mapVC.title = "Home"
        self.postVC.title = "Post"
        self.myProfileVC.title = "Profile"
        
        let pulleyController = PulleyViewController(contentViewController: self.mapVC, drawerViewController: self.myProfileVC)
        pulleyController.title = "Home"
        
        let controllers = [pulleyController,self.postVC,self.myProfileVC]
        self.tabbarTC.viewControllers = controllers

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        if UserModel.currentUser.isLogined() == false {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
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
