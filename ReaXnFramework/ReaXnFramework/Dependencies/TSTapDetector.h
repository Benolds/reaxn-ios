//
//  knockDetector.h
//  LocaleNatives
//
//  Created by Stephen Chan on 4/17/14.
//  Copyright (c) 2014 Stephen Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCoreMotionListener.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "ARAudioRecognizerDelegate.h"

@class TSTapDetector, ARAudioRecognizer;

@protocol TSTapDetectorDelegate <NSObject>

-(void)detectorDidDetectTap:(TSTapDetector *)detector;

@end

@interface TSTapDetector : NSObject <coreMotionListenerDelegate, ARAudioRecognizerDelegate> {
    CMDeviceMotion *currentDeviceMotion;
    CMDeviceMotion *lastDeviceMotion;
    CMAcceleration lastAccel;
    float jerk;
    float jounce;
    float normedAccel;
    float normedRotation;
    NSTimeInterval lastKnockTime;
    NSTimeInterval lastDoubleKnock;
    float filterConstant;
    double x;
    double y;
    double z;
    double lastX;
    double lastY;
    double lastZ;
    NSNumber *timeFromFirstKnock;
    CMAcceleration gravity;
    int accelUpdateCount;
    BOOL audioRecognized;
}

@property (strong, nonatomic) TSCoreMotionListener *listener;
@property (strong, nonatomic) id<TSTapDetectorDelegate> delegate;
@property (strong, nonatomic) ARAudioRecognizer *recognizer;

-(void)motionListener:(TSCoreMotionListener *)listener didReceiveDeviceMotion:(CMDeviceMotion *)deviceMotion;

@end
