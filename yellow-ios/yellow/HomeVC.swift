//
//  HomeVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class HomeVC: UIViewController,UITabBarControllerDelegate,FBSDKLoginButtonDelegate  {

    let tabbarTC = UITabBarController()
    let mapVC = MapVC()
    let postVC = PostDummyVC()
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
        
        let _ = Geohash.encode(latitude: 57.64911063015461, longitude: 10.40743969380855, length: 10)
        // s == "u4pruydqqv"
        
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16 , y: 50, width: view.frame.width - 32  , height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile", "user_friends"]
        
        if let user = Auth.auth().currentUser {
            print(user.uid)
            print(user.displayName)
            print(user.photoURL)
        }
        
    }
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        if( viewController == postVC){
            let realPostVC = PostVC()
            self.tabbarTC.present(realPostVC, animated: true, completion: nil)
           return false
        }
        return true
    }
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil{
            print(error)
        }
        else{
            print("User is SUccessfully Logged in....")
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString! else {
                return
            }
            let credentials =
                FacebookAuthProvider.credential(withAccessToken: accessTokenString )
            
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                
                
                if error != nil{
                    print(error!)
                    
                }
                print(user!)
            })
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, err) in
                
                if err != nil{
                    print("FBSDK request failed", err!)
                }
                else{
                    print(result!)
                }
                
            })
            
            
            
        }
    }
    
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        
        print("User SUccessfully Logged out")
        
    }

    func setTabbar(){
        self.mapVC.title = "Home"
        self.postVC.title = "Post"
        self.myProfileVC.title = "Profile"
        
        let controllers = [self.mapVC,self.postVC,self.myProfileVC]
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
