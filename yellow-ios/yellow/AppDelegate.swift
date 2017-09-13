//
//  AppDelegate.swift
//  yellow
//
//  Created by montionugera on 8/17/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var initialViewController :UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserModel.currentUser.getAsDatabase(completionHandler: {
            FirebaseApp.configure()
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let homeViewController = HomeVC()
            //let homeViewController = PostVC()
            homeViewController.view.backgroundColor = UIColor.red
            
            //setup facebook
            self.setUpFacebook(application,didFinishLaunchingWithOptions: launchOptions)
            self.window!.rootViewController = homeViewController
            self.window!.makeKeyAndVisible()
        })
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        let secondVc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        //        self.window!.rootViewController = secondVc
        //        self.window!.makeKeyAndVisible()
        
        //        for familyName in UIFont.familyNames {
        //            print("\n-- \(familyName) \n")
        //            for fontName in UIFont.fontNames(forFamilyName: familyName) {
        //                print(fontName)
        //            }
        //        }
        return true
    }
    func setUpFacebook(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.Alertlocation()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func Alertlocation() {
        var is_open_setting = true
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                is_open_setting = true
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                is_open_setting = false
            }
        } else {
            print("Location services are not enabled")
            is_open_setting = true
        }
        if(is_open_setting == true){
            let alertController = UIAlertController (title: appName, message: "Please open a location in setting", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
            alertController.addAction(settingsAction)
            self.window!.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if sourceApplication?.lowercased().range(of:"com.facebook") != nil {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                         open: url as URL!,
                                                                         sourceApplication: sourceApplication!,
                                                                         annotation: annotation)
        }
        else{
            return true
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        return handled
    }
    
    
}

