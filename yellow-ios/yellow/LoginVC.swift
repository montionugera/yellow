//
//  LoginVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginVC: BaseViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var fbLogin_view: FBSDKLoginButton!
    
    weak var mapvc_main: MapVC?
    
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
            self.showLoding()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LoginVC.delayDissmissFB), userInfo: nil, repeats: false)
        }
    }
    func delayDissmissFB() {
        self.callGraphAPIUserFB(fb_token_string: FBSDKAccessToken.current().tokenString)
    }
    func callGraphAPIUserFB(fb_token_string:String){
        print(fb_token_string)
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString! else {
            return
        }
        let credentials =
            FacebookAuthProvider.credential(withAccessToken: accessTokenString )
        
        
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
                    self.hideLoding()
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
                    
                    var user_profile_pic = ""
                    if fb_data?.object(forKey: "picture") != nil {
                        let picData = fb_data?.object(forKey: "picture") as! [String : AnyObject]
                        user_profile_pic = picData["data"]?["url"] as! String
                    }
                    
                    print(fb_data)
                    

                    Auth.auth().signIn(with: credentials, completion: { (user, error) in
                        self.hideLoding()
                        if error != nil{
                            print(error!)
                            self.showAlertDefault(msg: error as! String)
                        }
                        print(user!)
                        
                        let user_data_save = [
                            "user_id" : user?.uid ,
                            "user_email" : fb_data?.object(forKey: "email") ,
                            "user_name" : fb_data?.object(forKey: "name") ,
                            "user_profile" : user_profile_pic
                        ]
                        
                        UserModel.currentUser.saveAsDatabase(dict: user_data_save as [String : AnyObject])
                        
                        self.dismiss(animated: true, completion: {
                            if self.mapvc_main != nil {
                                self.mapvc_main?.fetchContent()
                            }
                        })
                        
                    })
                    
                    


                    
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
