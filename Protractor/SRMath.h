//
//  SRMath.h
//  Polliwog Go
//
//  Created by Rotek on 14-7.
//  Copyright (c) 2014年 Rotek. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface SRMath : NSObject

+ (GLKQuaternion)rotateQuaternionQ1:(GLKQuaternion)q1 withQuaternionQ2:(GLKQuaternion)q2;
+ (GLKQuaternion)createQuaternionFromVector0:(GLKVector3)v0 toVector1:(GLKVector3)v1;



@end

