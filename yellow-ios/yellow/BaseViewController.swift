//
//  ViewController.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showLoding(){
        if SVProgressHUD.isVisible() {
            
//            DispatchQueue.global(qos: .userInteractive).async {
                // Background Thread
//                DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }
        
//            SVProgressHUD.dismiss()
    
        }
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.show()
    }
    
    func hideLoding(){
//        DispatchQueue.global(qos: .userInteractive).async {
            // Background Thread
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
//        }
    }
    
    //MARK:Base Alert Dialog
    
    func showAlertDefault(msg : String){
        let alertController = UIAlertController(title: appName, message:msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {   (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
