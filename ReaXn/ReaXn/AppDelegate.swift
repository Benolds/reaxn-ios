//
//  AppDelegate.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TSTapDetectorDelegate {

    var window: UIWindow?
    var tapDetector: TSTapDetector!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // initialize tap detector
        self.tapDetector = TSTapDetector.init()
        self.tapDetector.listener.collectMotionInformationWithInterval(10)
        self.tapDetector.delegate = self
        
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(expirationCallback)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))

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
    
    // We should probably figure out what to do once the expiration times out.
    // Also, Swift closures confuse me so I defined a function handle.
    func expirationCallback() {
        
    }
    
    // Tap detection callback
    func detectorDidDetectTap(detector: TSTapDetector!) {
        createNotification()
    }
    
    func createNotification() {
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "Notification text goes here" // text that will be displayed in the notification
        notification.alertAction = "Action" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": NSUUID().UUIDString, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

}

