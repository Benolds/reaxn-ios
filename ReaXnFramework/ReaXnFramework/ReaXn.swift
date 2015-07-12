//
//  ReaXn.swift
//  ReaXnFramework
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import Foundation

public class ReaXn: NSObject, TSTapDetectorDelegate {
    
    var tapDetector: TSTapDetector!
    var callback: (() -> Void)!
    
    public init(callback: () -> Void, interval:Int = 10) {
        super.init()
        self.tapDetector = TSTapDetector()
        self.tapDetector.listener.collectMotionInformationWithInterval(Int32(interval))
        self.tapDetector.delegate = self
        
        self.callback = callback
    }
    
    public func detectorDidDetectTap(detector: TSTapDetector!) {
        callback()
    }
    
}
