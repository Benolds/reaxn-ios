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
    
    var phone : TCDevice?
    var connection : TCConnection?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // initialize tap detector
        self.tapDetector = TSTapDetector.init()
        self.tapDetector.listener.collectMotionInformationWithInterval(10)
        self.tapDetector.delegate = self
        
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(expirationCallback)
        
        registerForActionableNotifications()
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))

        return true
    }
    
    func registerForActionableNotifications() {
        // 1. Create the actions **************************************************
        // Open Action
        let helpAction = UIMutableUserNotificationAction()
        helpAction.identifier = "HELP_ACTION"
        helpAction.title = "Help"
        helpAction.activationMode = UIUserNotificationActivationMode.Background
        helpAction.authenticationRequired = false
        helpAction.destructive = false
        
        // 2. Create the category ***********************************************
        
        // Category
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = "HELP_CATEGORY"
        
        // A. Set actions for the default context
        actionCategory.setActions([helpAction],
            forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        actionCategory.setActions([helpAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: actionCategory) as Set<NSObject>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
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
        notification.category = "HELP_CATEGORY"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
            
            // Handle notification action *****************************************
            if notification.category == "HELP_CATEGORY" {
                
                if let action = identifier {
                    switch action{
                        case "HELP_ACTION":
//                            NSNotificationCenter.defaultCenter().postNotificationName("helpNotification", object: self, userInfo: notification.userInfo)
//                            NSNotificationCenter.defaultCenter().postNotificationName("receivedHelpNotification", object: self, userInfo: notification.userInfo)
                        
                            println("Help action triggered")
//                            dialNumber("6083957313")
                        
                            sendSMS()
                        
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                        default:
                            return
                    }
                }
            }
            completionHandler()
    }
    
//    func sendSMS() {
//        let token = "test123"
//        phone = TCDevice(capabilityToken: token, delegate: nil)
//    }
    
    //MARK: - Twilio
    
    func sendSMS() {
        println("Sending request.")
        
        let phoneNumberKevin = "+6083957313"
        let phoneNumberBen = "+6178179292"
        let phoneNumberSonny = "+6284449233"
        let phoneNumberTwilio = "+16694004715"
        
        var kTwilioSID: String = "ACba74031ab5f7675cd18641412e5f4b54" //"ACa13736d34d4cb736cb4fc21a0d784691"
        var kTwilioSecret: String = "16dd90718333f34e750a6c91ce499eb8" //"e2fa5de05efca921764d19f6c6806592"
        var kFromNumber: String = phoneNumberTwilio //phoneNumberBen
        var kToNumber: String = phoneNumberSonny //phoneNumberSonny
        var kMessage: String = "ReaXnTest"
        let urlString = "https://\(kTwilioSID):\(kTwilioSecret)@api.twilio.com/2010-04-01/Accounts/\(kTwilioSID)/SMS/Messages.json"
//        let urlString = "https://api.twilio.com/2010-04-01/Accounts/\(kTwilioSID)/SMS/Messages.json"
        
        if let url = NSURL(string: urlString) {
            var request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = url
            request.HTTPMethod = "POST"
            var bodyString: String = "From=\(kFromNumber)&To=\(kToNumber)&Body=\(kMessage)"
            
            if let data: NSData = bodyString.dataUsingEncoding(NSUTF8StringEncoding) {
                request.HTTPBody = data
//                
//                NSString *authStr = [NSString stringWithFormat:@"%@:", apiKey];
//                NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
//                NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
//                [request setValue:authValue forHTTPHeaderField:@"Authorization"];
                
                var response: NSURLResponse?
                var error: NSError?
                let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                }
            }
            
        }
    }
    
    func dialNumber(number : String) {
        let phoneNumber = "telprompt://\(number)"
        println("calling \(phoneNumber)")
        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
    }

}

