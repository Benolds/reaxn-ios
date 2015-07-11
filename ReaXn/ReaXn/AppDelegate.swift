//
//  AppDelegate.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 1. Create the actions **************************************************
        
        // increment Action
        let openAction = UIMutableUserNotificationAction()
        openAction.identifier = "OPEN_ACTION"
        openAction.title = "Open"
        openAction.activationMode = UIUserNotificationActivationMode.Foreground
        openAction.authenticationRequired = false
        openAction.destructive = false
        
//        // decrement Action
//        let decrementAction = UIMutableUserNotificationAction()
//        decrementAction.identifier = "DECREMENT_ACTION"
//        decrementAction.title = "Sub -1"
//        decrementAction.activationMode = UIUserNotificationActivationMode.Background
//        decrementAction.authenticationRequired = false
//        decrementAction.destructive = false
        
//        
//        // reset Action
//        let resetAction = UIMutableUserNotificationAction()
//        resetAction.identifier = "RESET_ACTION"
//        resetAction.title = "Reset"
//        resetAction.activationMode = UIUserNotificationActivationMode.Foreground
//        // NOT USED resetAction.authenticationRequired = true
//        resetAction.destructive = true
        
        // 2. Create the category ***********************************************
        
        // Category
        let openCategory = UIMutableUserNotificationCategory()
        openCategory.identifier = "OPEN_CATEGORY"
        
        // A. Set actions for the default context
        openCategory.setActions([openAction],
            forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        openCategory.setActions([openAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: openCategory) as Set<NSObject>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))  // types are UIUserNotificationType members
        
        return true
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Notifications
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName("receivedPushNotification", object: self, userInfo: notification.userInfo)
        
        // Handle notification action *****************************************
        if notification.category == "OPEN_CATEGORY" {
            println("open received")
        }
    }


}

