//
//  MyProfileVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import AlamofireImage
class MyProfileVC: UIViewController {
    @IBOutlet weak var profile_img: UIImageView!
    
    @IBOutlet weak var name_lb: UILabel!
    @IBOutlet weak var logout_bt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.name_lb.text = UserModel.currentUser.user_name
        
        if let profile_url = UserModel.currentUser.user_profile {
            self.profile_img.af_setImage(
                withURL: URL(string: profile_url)!,
                placeholderImage:  UIImage(named: "focus")!,
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: self.profile_img.frame.size,
                    radius: self.profile_img.frame.size.width/2
                )
            )
        }
        
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        if UserModel.currentUser.isLogined() == true {
            UserModel.currentUser.setAsLogOut()
            self.name_lb.text = ""
            self.logout_bt.setTitle("Login", for: .normal)
        }else{
//            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
//            self.present(loginVC,animated: true , completion: nil)

            DispatchQueue.main.async(execute: { () -> Void in
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                self.present(loginVC, animated: true, completion: nil)
            })
            
            self.logout_bt.setTitle("Logout", for: .normal)
            
            
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
