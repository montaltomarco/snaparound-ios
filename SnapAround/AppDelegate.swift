//
//  AppDelegate.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 28/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Mixpanel.sharedInstanceWithToken(mixpanelToken)
        //Mixpanel.sharedInstance().track("app opened")
        
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            // Fallback on earlier versions
            let types = UIRemoteNotificationType.Badge.union(.Sound).union(.Alert)
            application.registerForRemoteNotificationTypes(types)
        }
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        snapLog("Did Register for Remote Notifications with Device Token (\(deviceToken))");
        
        var deviceTokenString = String(format: "%@", deviceToken).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        deviceTokenString = deviceTokenString.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
        
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenString, forKey: "SnapDeviceToken")
        if let access = FBSDKAccessToken.currentAccessToken() {
            if let access = access.tokenString {
                APIUsers.registerForNotifications(access, deviceToken: deviceTokenString, completion: { (error) -> Void in
                    
                })
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        snapLog("Did Fail to Register for Remote Notifications");
        snapLog("\(error), \(error.localizedDescription)");
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        application.applicationIconBadgeNumber = 0;
        
        
        let state = UIApplication.sharedApplication().applicationState.rawValue
        NSUserDefaults.standardUserDefaults().setObject(state, forKey: "SnapNotificationState")
        NSNotificationCenter.defaultCenter().postNotificationName("SnapRemoteNotification", object: nil, userInfo: userInfo)
    }
    
    //ios8 Notifs
    @available(iOS 8.0, *)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
}

