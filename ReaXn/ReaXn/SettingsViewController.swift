//
//  ViewController.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var currentActionType = MainViewController.ActionType.Message

    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = getTitleForActionType(currentActionType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //or animated: false

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleHelpNotification:", name: "receivedHelpNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedHelpNotification", object: nil)
    }
    
    func getTitleForActionType(actionType : MainViewController.ActionType) -> String {
        switch actionType {
        case MainViewController.ActionType.Message:
            return "Messages"
        case MainViewController.ActionType.Call:
            return "Phone"
        case MainViewController.ActionType.VoiceMemo:
            return "Voice Memos"
        case MainViewController.ActionType.AddMore:
            return "Add More"
        }
    }
    
    //MARK: - UIActions
    
    @IBAction func saveNumber(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject(phoneNumberField.text, forKey: Constants.DefaultsKey_TwilioToPhoneNumber())
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let savedNumber: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.DefaultsKey_TwilioToPhoneNumber())
        println("savedNumber: \(savedNumber)")
    }
    
    @IBAction func saveMessage(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject(messageField.text, forKey: Constants.DefaultsKey_TwilioMessage())
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let savedMessage: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.DefaultsKey_TwilioMessage())
        println("savedMessage: \(savedMessage)")

    }
    
    //MARK: - Notifications
    
//    func handleOpenNotification(notification : NSNotification) {
//        println("handle help notification")
//        println(notification)
////        sendSMS()
//    }

}

