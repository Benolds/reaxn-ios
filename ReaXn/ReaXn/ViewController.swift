//
//  ViewController.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePushNotification:", name: "receivedPushNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedPushNotification", object: nil)
    }

    @IBAction func buttonPressed(sender: UIButton) {
        let timeDelayInSeconds = NSTimeInterval(15)
        println("Scheduling a notification in \(timeDelayInSeconds) seconds...")
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "Notification text goes here" // text that will be displayed in the notification
        notification.alertAction = "Action" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate().dateByAddingTimeInterval(timeDelayInSeconds) // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": NSUUID().UUIDString, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    //MARK: - Notifications
    
    func handlePushNotification(notification : NSNotification) {
        println("handle push notification")
        println(notification)
    }
    
    

}

