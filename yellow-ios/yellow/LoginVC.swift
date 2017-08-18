//
//  LoginVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var fbLogin_view: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupFB()
    }

    func setupFB(){

        self.fbLogin_view.delegate = self
        self.fbLogin_view.readPermissions = ["public_profile","email"]
        
        //        if !(UserModel.currentUser.isLogined()){
        FBSDKLoginManager().logOut()
        //        }
        
    }
    
    // MARK: Facebook Login
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool{
        return true
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(FBSDKAccessToken.current())
        } else if result.isCancelled {
            print("Cancelled")
        } else {
            print("LoggedIn")
            //self.showLoding()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LoginVC.delayDissmissFB), userInfo: nil, repeats: false)
        }
    }
    func delayDissmissFB() {
        self.callGraphAPIUserFB(fb_token_string: FBSDKAccessToken.current().tokenString)
    }
    func callGraphAPIUserFB(fb_token_string:String){
        print(fb_token_string)
        //sejf hide
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email,name,first_name,last_name,picture.type(large)"])
            .start(completionHandler:  { (connection, result, error) in
               
                if (error != nil) {
                    let alertController = UIAlertController(title: "Yellow", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    {   (result : UIAlertAction) -> Void in
                        
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    FBSDKLoginManager().logOut()
                    return
                }else{
                    guard let resultt = result as? NSDictionary, let _ = resultt["email"] as? String,
                        let _ = resultt["name"] as? String,
                        let _ = resultt["id"]  as? String
                        else {
                            return
                    }
                    
                    let fb_data = result as? NSDictionary
                    
                    var gender_data = ""
                    if fb_data?.object(forKey: "gender") != nil {
                        gender_data = fb_data?.object(forKey: "gender") as! String
                    }
                    
                    
                   
                    
                    let alert = UIAlertController(title: fb_data?.object(forKey: "email") as? String, message: "", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    {
                        (result : UIAlertAction) -> Void in
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: {
                        
                    })
                    
                    
                    
//                    self.login_now(emailSocial: fb_data?.object(forKey: "email") as! String,
//                                   username: fb_data?.object(forKey: "name") as! String,
//                                   gender: gender_data,
//                                   refID: fb_data?.object(forKey: "id") as! String,
//                                   with: "f")
//                    
                }
                
            })
        
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
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
