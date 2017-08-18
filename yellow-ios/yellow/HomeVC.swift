//
//  HomeVC.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginView(_ sender: Any) {
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.present(loginVC,animated: true,completion: nil)
    }
    
    @IBAction func openPostView(_ sender: Any) {
        self.present(PostVC(),animated: true,completion: nil)
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
