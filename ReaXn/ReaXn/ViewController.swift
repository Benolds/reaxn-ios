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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleHelpNotification:", name: "helpNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedHelpNotification", object: nil)
    }
    
    //MARK: - Notifications
    
    func handleOpenNotification(notification : NSNotification) {
        println("handle help notification")
        println(notification)        
    }


}

