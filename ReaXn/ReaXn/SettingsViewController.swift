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

    enum EditableFields {
        case Number
        case Message
        case None
    }
    
    var currentlyEditing : EditableFields = EditableFields.None
    
    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var messageField: UITextView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var locationInfoSwitch: UISwitch!
    @IBOutlet var knockKnockSwitch: UISwitch!
    
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
        
        currentlyEditing = EditableFields.None
        deleteButton.layer.cornerRadius = CGFloat(10)
        
        let prevLocationEnabled = NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsLocationInfoEnabledString())
        locationInfoSwitch.setOn(prevLocationEnabled, animated: false)
        
        let prevKnockKnockEnabled = NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsKnockKnockEnabledString())
        
        knockKnockSwitch.setOn(prevKnockKnockEnabled, animated: false)
        
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
    
    @IBAction func saveFields(sender: UIButton) {
        
        switch currentlyEditing {
        case EditableFields.Number:
            NSUserDefaults.standardUserDefaults().setObject(phoneNumberField.text, forKey: Constants.DefaultsKey_TwilioToPhoneNumber())
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let savedNumber: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.DefaultsKey_TwilioToPhoneNumber())
            println("savedNumber: \(savedNumber)")
            
        case EditableFields.Message:
            NSUserDefaults.standardUserDefaults().setObject(messageField.text, forKey: Constants.DefaultsKey_TwilioMessage())
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let savedMessage: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.DefaultsKey_TwilioMessage())
            println("savedMessage: \(savedMessage)")
            
        default:
            println("nothing currently being edited")
            
        }

        self.view.endEditing(true)
        
        currentlyEditing = EditableFields.None

    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.hidden = false
        currentlyEditing = EditableFields.Number
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveButton.hidden = true
        currentlyEditing = EditableFields.None

    }
    
    @IBAction func numberFieldChanged(sender: UITextField) {
        if let fieldText = sender.text {
            if count(fieldText) >= 10 {
                saveButton.enabled = true
            } else {
                saveButton.enabled = false
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        saveButton.hidden = false
        currentlyEditing = EditableFields.Message
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        saveButton.hidden = true
        currentlyEditing = EditableFields.None
    }
    
    func textViewDidChange(textView: UITextView) {
        if let fieldText = textView.text {
            if count(fieldText) > 0 {
                saveButton.enabled = true
            } else {
                saveButton.enabled = false
            }
        }
    }
    
    @IBAction func locationInfoSwitchChanged(sender: UISwitch) {
        
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: Constants.DefaultsLocationInfoEnabledString())
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let locationInfoEnabled: AnyObject? = NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsLocationInfoEnabledString())
        println("set locationInfoEnabled: \(locationInfoEnabled)")
        
    }
    
    @IBAction func knockKnockSwitchChanged(sender: UISwitch) {
        
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: Constants.DefaultsKnockKnockEnabledString())
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let knockKnockEnabled: AnyObject? = NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsKnockKnockEnabledString())
        println("set knockKnockEnabled: \(knockKnockEnabled)")
        
    }

}

