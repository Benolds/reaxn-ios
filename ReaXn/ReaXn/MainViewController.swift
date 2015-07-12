//
//  MainViewController.swift
//  ReaXn
//
//  Created by Benjamin Reynolds on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    enum ActionType {
        case Message
        case Call
        case VoiceMemo
        case AddMore
    }
    
    enum ActionState {
        case Waiting
        case Done
    }
    
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var previousTypeButton: UIButton!
    @IBOutlet var nextTypeButton: UIButton!
    @IBOutlet var sentSuccessfullyLabel: UILabel!
    @IBOutlet var actionTypeLabel: UILabel!
    
    var currentActionState : ActionState = ActionState.Waiting
    var currentActionType : ActionType = ActionType.Message

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true) //or animated: false
        
        self.refreshViewForActionType(self.currentActionType, newActionState: self.currentActionState)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    func refreshViewForActionType(newActionType : ActionType, newActionState : ActionState) {
        
        self.currentActionType = newActionType
        self.currentActionState = newActionState
        
        if newActionState == ActionState.Waiting {
            
            switch newActionType {
            case ActionType.Message:
                self.view.backgroundColor = UIColor(red:0.47, green:0.80, blue:0.83, alpha:1.0)
                actionButton.setImage(UIImage(named: "MessageBig"), forState: UIControlState.Normal)
                
            case ActionType.Call:
                self.view.backgroundColor = UIColor(red:0.94, green:0.47, blue:0.54, alpha:1.0)
                actionButton.setImage(UIImage(named: "PhoneBig"), forState: UIControlState.Normal)

            case ActionType.VoiceMemo:
                self.view.backgroundColor = UIColor(red:0.98, green:0.73, blue:0.29, alpha:1.0)
                actionButton.setImage(UIImage(named: "VoiceBig"), forState: UIControlState.Normal)

            case ActionType.AddMore:
                self.view.backgroundColor = UIColor(red:0.15, green:0.18, blue:0.33, alpha:1.0)
                actionButton.setImage(UIImage(named: "PlusBig"), forState: UIControlState.Normal)

            }
            
            sentSuccessfullyLabel.hidden = true
            
        } else {
            
            switch currentActionType {
            case ActionType.Message:
                self.view.backgroundColor = UIColor(red:0.33, green:0.80, blue:0.82, alpha:1.0)
                actionButton.setImage(UIImage(named: "MessageBigDone"), forState: UIControlState.Normal)

            case ActionType.Call:
                self.view.backgroundColor = UIColor(red:0.94, green:0.38, blue:0.45, alpha:1.0)
                actionButton.setImage(UIImage(named: "PhoneBigDone"), forState: UIControlState.Normal)

            case ActionType.VoiceMemo:
                self.view.backgroundColor = UIColor(red:0.98, green:0.69, blue:0.20, alpha:1.0)
                actionButton.setImage(UIImage(named: "VoiceBigDone"), forState: UIControlState.Normal)

            case ActionType.AddMore:
                self.view.backgroundColor = UIColor(red:0.15, green:0.18, blue:0.33, alpha:1.0)
                actionButton.setImage(UIImage(named: "PlusBig"), forState: UIControlState.Normal)

            }
            
            sentSuccessfullyLabel.hidden = false
            
        }
        
        updateAppForActionType(newActionType)
        
    }
    
    func updateAppForActionType(actionType : ActionType) {
        switch actionType {
        case ActionType.Message:
            actionTypeLabel.text = "MESSAGES"
            sentSuccessfullyLabel.text = "Sent Successfully"
            previousTypeButton.setImage(UIImage(named: "PlusSmall"), forState: UIControlState.Normal)
            nextTypeButton.setImage(UIImage(named: "PhoneSmall"), forState: UIControlState.Normal)
            
            NSUserDefaults.standardUserDefaults().setObject(Constants.DefaultsMessagesString(), forKey: Constants.DefaultsKey_ActionType())
            
            settingsButton.hidden = false
            
        case ActionType.Call:
            actionTypeLabel.text = "PHONE"
            sentSuccessfullyLabel.text = "Calling..."
            previousTypeButton.setImage(UIImage(named: "MessageSmall"), forState: UIControlState.Normal)
            nextTypeButton.setImage(UIImage(named: "VoiceSmall"), forState: UIControlState.Normal)
            
            NSUserDefaults.standardUserDefaults().setObject(Constants.DefaultsPhoneString(), forKey: Constants.DefaultsKey_ActionType())
            
            settingsButton.hidden = false
            
        case ActionType.VoiceMemo:
            actionTypeLabel.text = "VOICE MEMOS"
            sentSuccessfullyLabel.text = "00:00:24"
            previousTypeButton.setImage(UIImage(named: "PhoneSmall"), forState: UIControlState.Normal)
            nextTypeButton.setImage(UIImage(named: "PlusSmall"), forState: UIControlState.Normal)
            
            NSUserDefaults.standardUserDefaults().setObject(Constants.DefaultsVoiceMemosString(), forKey: Constants.DefaultsKey_ActionType())

            settingsButton.hidden = false

            
        case ActionType.AddMore:
            actionTypeLabel.text = "ADD MORE"
            previousTypeButton.setImage(UIImage(named: "VoiceSmall"), forState: UIControlState.Normal)
            nextTypeButton.setImage(UIImage(named: "MessageSmall"), forState: UIControlState.Normal)
            
            settingsButton.hidden = true
            
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()

    }
    
    @IBAction func triggerAction(sender: UIButton) {
        
        if self.currentActionState == ActionState.Waiting {
            
            self.refreshViewForActionType(self.currentActionType, newActionState: ActionState.Done)
            
            if self.currentActionType == ActionType.Message {
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.sendSMS()
                }
            }
            
            delay(10.0) {
                self.refreshViewForActionType(self.currentActionType, newActionState: ActionState.Waiting)
            }
            
        } /*else {
            self.refreshViewForActionType(self.currentActionType, newActionState: ActionState.Waiting)
        }*/
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    @IBAction func switchNextAction(sender: UIButton) {
        switch self.currentActionType {
        case ActionType.Message:
            refreshViewForActionType(ActionType.Call, newActionState: ActionState.Waiting)
        case ActionType.Call:
            refreshViewForActionType(ActionType.VoiceMemo, newActionState: ActionState.Waiting)
        case ActionType.VoiceMemo:
            refreshViewForActionType(ActionType.AddMore, newActionState: ActionState.Waiting)
        case ActionType.AddMore:
            refreshViewForActionType(ActionType.Message, newActionState: ActionState.Waiting)

        }
    }
    
    @IBAction func switchPrevAction(sender: UIButton) {
        switch self.currentActionType {
        case ActionType.Message:
            refreshViewForActionType(ActionType.AddMore, newActionState: ActionState.Waiting)
        case ActionType.Call:
            refreshViewForActionType(ActionType.Message, newActionState: ActionState.Waiting)
        case ActionType.VoiceMemo:
            refreshViewForActionType(ActionType.Call, newActionState: ActionState.Waiting)
        case ActionType.AddMore:
            refreshViewForActionType(ActionType.VoiceMemo, newActionState: ActionState.Waiting)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let settingsViewController = segue.destinationViewController as? SettingsViewController {
            settingsViewController.currentActionType = self.currentActionType
        }
    }
    

}
