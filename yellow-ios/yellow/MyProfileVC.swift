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
    
    var main_vct:HomeVC? = nil
    
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
        if UserModel.currentUser.isLogined() == true {

            self.logout_bt.setTitle("Logout", for: .normal)
        }else{
            self.logout_bt.setTitle("Login", for: .normal)
        }
    }
    @IBAction func logoutClick(_ sender: Any) {
        if UserModel.currentUser.isLogined() == true {
            UserModel.currentUser.setAsLogOut()
            self.name_lb.text = ""
            self.profile_img.image = UIImage()
            self.logout_bt.setTitle("Login", for: .normal)
        }else{

            self.main_vct?.goLogin()
            
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
