//
//  ViewController.swift
//  ReaXn
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleHelpNotification:", name: "receivedHelpNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedHelpNotification", object: nil)
    }
    
    //MARK: - UIActions
    
    @IBAction func saveNumber(sender: UITextField) {
        NSUserDefaults.standardUserDefaults().setObject(sender.text, forKey: "twilioToPhoneNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let savedNumber = NSUserDefaults.standardUserDefaults().objectForKey("twilioToPhoneNumber")
        println("savedNumber: \(savedNumber)")
    }
    
    @IBAction func saveMessage(sender: UITextField) {
        NSUserDefaults.standardUserDefaults().setObject(sender.text, forKey: "twilioMessage")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let savedMessage = NSUserDefaults.standardUserDefaults().objectForKey("twilioMessage")
        println("savedMessage: \(savedMessage)")

    }
    
    //MARK: - Notifications
    
    func handleOpenNotification(notification : NSNotification) {
        println("handle help notification")
        println(notification)
//        sendSMS()
    }

}

