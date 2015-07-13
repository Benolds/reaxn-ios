//
//  coreMotionListener.h
//  LocaleNatives
//
//  Created by Stephen Chan on 12/31/13.
//  Copyright (c) 2013 Stephen Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class TSCoreMotionListener;

@protocol coreMotionListenerDelegate <NSObject>

- (void)motionListener:(TSCoreMotionListener *)listener didReceiveDeviceMotion:(CMDeviceMotion *)deviceMotion;

@end

@interface TSCoreMotionListener : NSObject

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) id <coreMotionListenerDelegate> delegate;
@property (strong, readonly) NSMutableArray *deviceMotionArray;
@property (strong, nonatomic) NSNumber *measurementInterval;

-(void)collectMotionInformationWithInterval:(int)interval;
-(void)stopCollectingMotionInformation;

@end
