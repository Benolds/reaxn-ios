//
//  ARAudioRecognizer.m
//  Audio Recognizer
//
//  Created by Anthony Picciano on 6/6/13.
//  Copyright (c) 2013 Anthony Picciano. All rights reserved.
//

#import "ARAudioRecognizer.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <math.h>

@interface ARAudioRecognizer ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;
@property (nonatomic, strong) NSTimer *resetRecognizedTimer;

- (void)initializeRecorder;
- (void)initializeLevelTimer;

@end

@implementation ARAudioRecognizer

@synthesize delegate = _delegate;
@synthesize sensitivity = _sensitivity, frequency = _frequency, lastHighPassResults = _lastHighPassResults, highPassResults = _highPassResults;

- (id)init
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    return [self initWithSensitivity:0.0
                           frequency:0.01];
}

- (id)initWithSensitivity:(float)sensitivity frequency:(float)frequency
{
    if (self = [super init]) {
        _sensitivity = sensitivity;
        _frequency = frequency;
        _highPassResults = 0.0f;
    }
    
    [self initializeRecorder];
    return self;
}

- (void)initializeRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (self.recorder) {
  		[self.recorder prepareToRecord];
  		[self.recorder setMeteringEnabled:YES];
  	} else
  		NSLog(@"Error in initializeRecorder: %@", [error description]);
}

-(void)stopRecorder
{
    [self.recorder stop];
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    [self.delegate audioRecognizer:self recognized:NO];
    //[self.resetRecognizedTimer invalidate];
    //self.resetRecognizedTimer = nil;
}

-(void)resetRecognized
{
    //[self.delegate audioRecognizer:self recognized:NO];
}

-(void)startRecorder
{
    [self.recorder record];
    [self initializeLevelTimer];
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(stopRecorder) userInfo:nil repeats:NO];
    //self.resetRecognizedTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(resetRecognized) userInfo:nil repeats:YES];
}

- (void)initializeLevelTimer
{
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval:_frequency  target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

- (void)levelTimerCallback:(NSTimer *)timer
{
    // RC = 1/(2*pi*fc) where fc is cutoff frequency
    // ALPHA = dt / ( dt + RC )
    const double fc = 7;
    double dt = 1.0 / _frequency;
    double RC = 1.0 / (2 * M_PI * fc);
    
	[self.recorder updateMeters];
    
    const double ALPHA = dt / (dt + RC);
	double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    
    _highPassResults = ALPHA * (_highPassResults + peakPowerForChannel - _lastHighPassResults);
    _lastHighPassResults = _highPassResults;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioLevelUpdated:level:)]) {
        [self.delegate audioLevelUpdated:self level:self.highPassResults];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioLevelUpdated:averagePower:peakPower:)]) {
        [self.delegate audioLevelUpdated:self averagePower:[self.recorder averagePowerForChannel:0] peakPower:[self.recorder peakPowerForChannel:0]];
    }
    
	if (self.highPassResults > _sensitivity && self.delegate && [self.delegate respondsToSelector:@selector(audioRecognizer:recognized:)]) {
        NSLog(@"audio recognized");
        [self.delegate audioRecognizer:self recognized:YES];
    }
}

@end
