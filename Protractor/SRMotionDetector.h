//
//  SRMotionDetector.h
//  Polliwog Go
//
//  Created by Rotek on 3/7/14.
//  Copyright (c) 2014 Rotek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>



@interface SRMotionDetector : NSObject

+ (id)sharedInstance;

@property (nonatomic,assign,readonly) float rotation;
@property (nonatomic,assign,readonly) float scale;
@property (nonatomic,assign,readonly) float measureAngle;
@property (nonatomic,assign,readonly) float freeAngle;

- (void)reset;
- (void)startUpdate;
- (void)stopUpdate;

- (void)confirmFirstVector;
- (void)confirmSecondVector;
- (void)restartMeasure;

@end
