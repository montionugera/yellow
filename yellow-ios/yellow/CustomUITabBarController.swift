//
//  CustomUITabBarController.swift
//  yellow
//
//  Created by ekachai limpisoot on 9/6/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit

class CustomUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBar.tintColor = UIColor.black
        
    }
    override func viewWillLayoutSubviews() {
        var newTabBarFrame = tabBar.frame
        
        let newTabBarHeight: CGFloat = 69
        newTabBarFrame.size.height = newTabBarHeight
        newTabBarFrame.origin.y = self.view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newTabBarFrame
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
