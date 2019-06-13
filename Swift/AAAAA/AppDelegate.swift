//
//  AppDelegate.swift
//  TrainGo-CP
//
//  Created by pranjay on 4/8/16.
//  Copyright © 2016 clicklabs. All rights reserved.
//

import UIKit
import Kingfisher
import Stripe
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import UserNotifications

var url = URL(string: "\(ServerLink.socketLink)")!
let socket = SocketIOClient(socketURL: url)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        GMSServices.provideAPIKey(ServerKey.googleMapKey)
        Stripe.setDefaultPublishableKey(liveStripePublisherKey)
        Flurry.startSession("CCJKN6TKFKJHP3JKGKQG")
        Fabric.with([STPAPIClient.self, Crashlytics.self])
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
                if error == nil{
                    application.registerForRemoteNotifications()
                }
            }
        }
        else if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            
            let types:UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } 


        socket.on("trainGo") {data, ack in
            println("Message for you! \(data)")
//            ack?("I got your message, and I'll send my response")
            socket.emit("response", "Hello!")
        }
       
           
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.emitSockets), name: NSNotification.Name(rawValue: NSKeys.chatObserver), object: nil)
        
        UserDefaults.standard.set(false, forKey: NSKeys.loginGuest)
        
        
        let _: String = String(UIApplicationLaunchOptionsKey.remoteNotification.rawValue)
        if let options = launchOptions  {
            if let dictionary = options[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                let triggerTime = (Int64(NSEC_PER_SEC) * 3)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                     self.handlepush(dictionary as! [AnyHashable: Any])
                })

               
            }
        }

        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func emitSockets(_ notification:Notification){
        socket.emit("authentication", (notification as NSNotification).userInfo!)
        socket.on("authenticated") { (data, ack) in
            
            println(data[0])
            if(data[0] as! String == "Success!"){
            UserDefaults.standard.set(true, forKey: NSKeys.canSendMessage)
            }else{
                UserDefaults.standard.set(false, forKey: NSKeys.canSendMessage)
            }
        }
        socket.on("unauthorized") { (data, ack) in
             UserDefaults.standard.set(false, forKey: NSKeys.canSendMessage)
        }
    }
    // MARK: Push Notification Methods
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        if  (UserDefaults.standard.value(forKey: NSKeys.deviceToken) == nil)
        {
            UserDefaults.standard.setValue("123456", forKey: NSKeys.deviceToken)
        }
        UserDefaults.standard.synchronize()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification with fetchCompletionHandler called")
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            self.handlepush(userInfo)
        })
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print(userInfo)
        if application.applicationState == UIApplicationState.active{
            print("didReceiveRemoteNotification called")
            self.handlepush(userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        if UIApplication.shared.applicationState == UIApplicationState.active{
            print("didReceiveRemoteNotification called")
            self.handlepush(response.notification.request.content.userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        completionHandler([.alert, .sound])
    }
    
    func handlepush(_ userInfo: [AnyHashable: Any])
    {
        NSLog("user info \(userInfo)")
        print(userInfo)
        if (UserDefaults.standard.value(forKey: NSKeys.accessToken as String) as? String) != nil
        {
            if let flagStr = userInfo["flag"]
            {
                
                let flag = Int(flagStr as! String)
                
                if  flag != 1 && flag != 12
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NSKeys.pushNotificationObserver), object: nil, userInfo: userInfo)
                    
                }else if  (flag == 12 || flag == 14) {
                    
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NSKeys.pushNotificationTrainer), object: nil, userInfo: userInfo)
                }else{
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NSKeys.pushNotificationChat), object: nil, userInfo: userInfo)
                }

               
                
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0 ..< deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        } 
        
        UserDefaults.standard.setValue(tokenString, forKey: NSKeys.deviceToken)
        UserDefaults.standard.synchronize()
        print("tokenString: \(tokenString)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        socket.connect()

        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }


}

