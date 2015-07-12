//
//  knockDetector.m
//  LocaleNatives
//
//  Created by Stephen Chan on 4/17/14.
//  Copyright (c) 2014 Stephen Chan. All rights reserved.
//

#import "TSTapDetector.h"
#import "ARAudioRecognizer.h"

@implementation TSTapDetector

-(instancetype)init
{
    self = [super init];
    if (self) {
        jerk = 0;
        self.listener = [[TSCoreMotionListener alloc] init];
        self.listener.delegate = self;
        [self setFilterConstantWithSampleRate:0.01 cutoffFrequency:7];
        self.recognizer = [[ARAudioRecognizer alloc] init];
        self.recognizer.delegate = self;
    }
    return self;
}

-(void)audioRecognizer:(ARAudioRecognizer *)recognizer recognized:(BOOL)recognized
{
    audioRecognized = recognized;
}

double normAll(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
}

-(void)motionListener:(TSCoreMotionListener *)listener didReceiveDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    [self processDeviceMotion:deviceMotion withListener:listener filter:@"highPass"];
    if ([self satisfiesDoubleKnock]) {
        lastDoubleKnock = deviceMotion.timestamp;
        lastKnockTime = 0;
        audioRecognized = NO;
        timeFromFirstKnock = [NSNumber numberWithFloat:fabsf(deviceMotion.timestamp - lastKnockTime)];
        [self.recognizer stopRecorder];
        [self.delegate detectorDidDetectTap:self];
        NSLog(@"got a new knock");
    }
    if ([self satisfiesKnockThresholds]) {
        NSLog(@"%f", jounce);
        NSLog(@"%f", jerk);
        NSLog(@"%f", normedAccel);
        NSLog(@"%f", normedRotation);
        lastKnockTime = deviceMotion.timestamp;
        [self.recognizer startRecorder];
    } else if (fabsf(deviceMotion.timestamp - lastKnockTime) > 1) {
    }
}

- (void)processDeviceMotion:(CMDeviceMotion *)deviceMotion withListener:(TSCoreMotionListener *)listener filter:(NSString *)filter
{
    // setting accel
    currentDeviceMotion = deviceMotion;
    CMAcceleration accel = [self HighPassAccelerationFromDeviceMotion:deviceMotion];
    
    double measurementInterval = deviceMotion.timestamp - lastDeviceMotion.timestamp;
    normedAccel = normAll( accel.x, accel.y, accel.z );
    // setting last accel
    float lastNormedAccel = normAll( lastAccel.x, lastAccel.y, lastAccel.z);
    // setting jerk
    float newJerk = fabsf(lastNormedAccel - normedAccel) / measurementInterval;
    // set rotation
    CMRotationRate rotation = currentDeviceMotion.rotationRate;
    normedRotation = normAll( rotation.x, rotation.y, rotation.z );
    // set jounce
    jounce = fabsf(jerk - newJerk) / [listener.measurementInterval floatValue];
    // set jerk
    jerk = newJerk;
    // set lastDeviceMotion
    lastDeviceMotion = deviceMotion;
    lastAccel = accel;
    gravity = deviceMotion.gravity;
}

- (BOOL)satisfiesKnockThresholds
{
    float lastDoubleKnockTimeDifference = fabsf(currentDeviceMotion.timestamp - lastDoubleKnock);
    float lastKnockTimeDifference = fabsf(currentDeviceMotion.timestamp - lastKnockTime);
    float total = -0.22 + (0.03 * jounce) - (normedRotation * 0.08);
    float odds = 1 / (1 + exp(-total));
    //[self logitBoostKnock];
    /* odds > 0.58 */
    return odds > 0.58 && lastDoubleKnockTimeDifference > 1 && lastKnockTimeDifference > 0.1;
}

- (BOOL)satisfiesDoubleKnock
{
    float lastKnockTimeDifference = fabsf(currentDeviceMotion.timestamp - lastKnockTime);
    // no audio
    return [self satisfiesKnockThresholds] && lastKnockTimeDifference > 0.10 && lastKnockTimeDifference < 0.7;
}

-(BOOL)logitBoostKnock
{
    double total = 0;
    /* calculate jounce contribution to total */
    if (jounce <= 9.4732545) {
        total -= 1.2;
    } else {
        total += 0.5311475409836065;
    }
    if (jounce <= 41.208349999999996) {
        total -= 0.14738448324598247;
    } else {
        total += 1.1848363589436224;
    }
    if (jounce <= 30.05095) {
        total -= 0.23166596475047346;
    } else {
        total += 0.43919239332780213;
    }
    /* calculate jerk contribution to total */
    if (jerk <= 0.40138815) {
        total += 0.11985033796972121;
    } else {
        total -= 0.7121179422645223;
    }
    /* calculate rotation contribution to total */
    if (normedRotation <= 2.7320685) {
        total += 0.4686688930146794;
    } else {
        total -= 0.44237738128966225;
    }
    /* calculate accel contribution to total */
    if (normedAccel <= 0.005429732) {
        total -= 0.15024932298031465;
    } else {
        total += 1.2634045721612126;
    }
    if (normedAccel <= 3.6475305E-4) {
        total -= 1.2849215384090564;
    } else {
        total += 0.1535620136303905;
    }
    if (normedAccel <= 0.0024101455) {
        total += 0.8198849637798997;
    } else {
        total -= 0.11058302371275855;
    }
    if (normedAccel <= 0.0064382585) {
        total -= 0.05142796711731719;
    } else {
        total += 1.385527706927004;
    }
    if (normedAccel <= 3.6475305E-4) {
        total -= 0.9255592003250911;
    } else {
        total += 0.06451991333114095;
    }
    double odds = 1 / (1 + exp(-total));
    if (odds >= 0.8) {
        NSLog(@"Logit boost odds: %f", odds);
    }
    return odds >= 0.8;
}

/*
Iteration 2
Class 1 (Knock=       T)
Decision Stump
Classifications
rotation    <= 2.7320685 : 0.4686688930146794
rotation    > 2.7320685 : -0.44237738128966225
rotation    is missing : -0.03288171682948263
Iteration 9
Class 1 (Knock=       T)
Decision Stump
Classifications
jerk           <= 0.40138815 : 0.11985033796972121
jerk           > 0.40138815 : -0.7121179422645223
jerk           is missing : 0.013598808370154295
Iteration 1
Class 1 (Knock=       T)
Decision Stump
Classifications
jounce        <= 9.4732545 : -1.2
jounce        > 9.4732545 : 0.5311475409836065
jounce        is missing : 0.013793103448275862
Iteration 5
Class 1 (Knock=       T)
Decision Stump
Classifications
jounce        <= 41.208349999999996 : -0.14738448324598247
jounce        > 41.208349999999996 : 1.1848363589436224
jounce        is missing : -0.02698605549253949
Iteration 7
Class 1 (Knock=       T)
Decision Stump
Classifications
jounce        <= 30.05095 : -0.23166596475047346
jounce        > 30.05095 : 0.43919239332780213
jounce        is missing : -0.008213149574337393
Iteration 3
Class 1 (Knock=       T)
Decision Stump
Classifications
accel            <= 0.005429732 : -0.15024932298031465
accel            > 0.005429732 : 1.2634045721612126
accel            is missing : 0.011205780999682939
Iteration 4
Class 1 (Knock=       T)
Decision Stump
Classifications
accel            <= 3.6475305E-4 : -1.2849215384090564
accel            > 3.6475305E-4 : 0.1535620136303905
accel            is missing : 0.02656947558973651
Iteration 6
Class 1 (Knock=       T)
Decision Stump
Classifications
accel            <= 0.0024101455 : 0.8198849637798997
accel            > 0.0024101455 : -0.11058302371275855
accel            is missing : 0.0226708047819344
Iteration 8
Class 1 (Knock=       T)
Decision Stump
Classifications
accel            <= 0.0064382585 : -0.05142796711731719
accel            > 0.0064382585 : 1.385527706927004
accel            is missing : 0.006872832924468824
Iteration 10
Class 1 (Knock=       T)
Decision Stump
Classifications
accel            <= 3.6475305E-4 : -0.9255592003250911
accel            > 3.6475305E-4 : 0.06451991333114095
accel            is missing : 4.355987880493462E-4
*/

- (void)setFilterConstantWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
    double dt = 1.0 / rate;
    double RC = 1.0 / freq;
    filterConstant = RC / (dt + RC);
}

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0

- (CMAcceleration)HighPassAccelerationFromDeviceMotion:(CMDeviceMotion *)DM
{
    // takes a CMDeviceMotion and returns it as a CMAcceleration struct
    
	double alpha = filterConstant;
	BOOL adaptive = NO;
	if (adaptive)
	{
		/*float d = Clamp(fabs(normAll(x, y, z) - normAll(DM.userAcceleration.x, DM.userAcceleration.y, DM.userAcceleration.z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
         alpha = d * filterConstant / kAccelerometerNoiseAttenuation + (1.0 - d) * filterConstant;*/
	}
	
	x = alpha * (x + DM.userAcceleration.x - lastX);
	y = alpha * (y + DM.userAcceleration.y - lastY);
	z = alpha * (z + DM.userAcceleration.z - lastZ);
	
	lastX = DM.userAcceleration.x;
	lastY = DM.userAcceleration.y;
	lastZ = DM.userAcceleration.z;
    
    CMAcceleration acceleration;
    acceleration.x = x;
    acceleration.y = y;
    acceleration.z = z;
    return acceleration;
}

@end
