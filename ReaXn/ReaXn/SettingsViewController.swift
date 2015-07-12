//
//  ViewController.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentActionType = MainViewController.ActionType.Message

    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var saveNumberButton: UIButton!
    @IBOutlet var saveMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = getTitleForActionType(currentActionType)
        
        // Status bar white font
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
        
        self.view.endEditing(true)
    }
    
    func saveMessage() {
        NSUserDefaults.standardUserDefaults().setObject(messageField.text, forKey: Constants.DefaultsKey_TwilioMessage())
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let savedMessage: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.DefaultsKey_TwilioMessage())
        println("savedMessage: \(savedMessage)")
        
        self.view.endEditing(true)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func numberFieldChanged(sender: UITextField) {
        if let fieldText = sender.text {
            if count(fieldText) >= 10 {
                saveNumberButton.enabled = true
            } else {
                saveNumberButton.enabled = false
            }
        }
    }
    
//    @IBAction func messageFieldChanged(sender: UITextField) {
//
//    }
    
    func textViewDidChange(textView: UITextView) {
        if let fieldText = textView.text {
            if count(fieldText) > 0 {
                saveMessageButton.enabled = true
            } else {
                saveMessageButton.enabled = false
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            saveMessage()
            return false
        }
        
        return true
        
    }
    
    //MARK: - Notifications
    
//    func handleOpenNotification(notification : NSNotification) {
//        println("handle help notification")
//        println(notification)
////        sendSMS()
//    }

}

