//
//  AddMoreViewController.swift
//  ReaXn
//
//  Created by Benjamin Reynolds on 7/12/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import Foundation
import UIKit

class AddMoreViewController: UIViewController {
    
    var currentActionType = MainViewController.ActionType.Message
    
    override func viewDidLoad() {
        self.title = getTitleForActionType(currentActionType)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //or animated: false
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


}
