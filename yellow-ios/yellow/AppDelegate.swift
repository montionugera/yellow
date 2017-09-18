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
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,MessagingDelegate {
    var window: UIWindow?
    var initialViewController :UIViewController?
    let homeViewController = HomeVC()
    var timeInterval:TimeInterval?
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("didRefreshRegistrationToken fcmToken:\(fcmToken)")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("MessagingAppData:\(remoteMessage.appData)")
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isDone, error) in
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        print("fcmToken:\(Messaging.messaging().fcmToken)")
        UserModel.currentUser.getAsDatabase(completionHandler: {
            AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.homeViewController.view.backgroundColor = UIColor.red
            // setup facebook
            self.setUpFacebook(application,didFinishLaunchingWithOptions: launchOptions)
            //let path = "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"
            //let url = URL(string: path)
            //let videoVC = VideoViewController(videoURL: url!)
            self.window!.rootViewController = self.homeViewController
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
        
        
        timeInterval = Date().timeIntervalSince1970
        
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
        self.homeViewController.goLogin()
        self.Alertlocation()
        
        // check > 24 hr , code duplicate will remove later
        if(self.timeAgo24Hr( Date(timeIntervalSince1970: TimeInterval(timeInterval!)) , currentDate: Date()) == true){
            self.homeViewController.fecthNewData()
            timeInterval = Date().timeIntervalSince1970
        }
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func Alertlocation() {
//        var is_open_setting = true
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//                is_open_setting = true
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//                is_open_setting = false
//            }
//        } else {
//            print("Location services are not enabled")
//            is_open_setting = true
//        }
//        if(is_open_setting == true){
//            let alertController = UIAlertController (title: appName, message: "Please open a location in setting", preferredStyle: .alert)
//            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
//                    return
//                }
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)") // Prints true
//                        })
//                    } else {
//                        UIApplication.shared.openURL(settingsUrl)
//                    }
//                }
//            }
//            alertController.addAction(settingsAction)
//            self.window!.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
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
    
   
    func timeAgo24Hr(_ date:Date,currentDate:Date) -> Bool {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return true
        } else if (components.year! >= 1){
            return true
        } else if (components.month! >= 2) {
            return true
        } else if (components.month! >= 1){
            return true
        } else if (components.weekOfYear! >= 2) {
            return true
        } else if (components.weekOfYear! >= 1){
            return true
        } else if (components.day! >= 2) {
            return true
        } else if (components.day! >= 1){
            return true
        } else if (components.hour! >= 2) {
            return false
        } else if (components.hour! >= 1){
            return false
        } else if (components.minute! >= 2) {
            return false
        } else if (components.minute! >= 1){
            return false
        } else if (components.second! >= 3) {
            return false
        } else {
            return false
        }
        
    }
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //if response.notification.request.content.userInfo.isEmpty {
        //  let userInfo = response.notification.request.content.userInfo
        //}
        //        print("attachment:\(response.notification.request.content.attachments[0].url)")
        //        let image = UIImage(contentsOfFile: response.notification.request.content.attachments[0].url.absoluteString)
        let url = response.notification.request.content.attachments[0].url
        let userInfo = response.notification.request.content.userInfo
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
}

