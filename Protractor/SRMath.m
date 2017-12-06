//
//  SRMath.m
//  Polliwog Go
//
//  Created by Rotek on 14-07
//  Copyright (c) 2014年 Rotek. All rights reserved.
//

#import "SRMath.h"

@implementation SRMath

+ (GLKQuaternion)rotateQuaternionQ1:(GLKQuaternion)q1 withQuaternionQ2:(GLKQuaternion)q2
{
    GLKQuaternion q;
    q.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    q.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    q.y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
    q.z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;
    
    q = GLKQuaternionNormalize(q);
    return q;
    
}



+ (GLKQuaternion)createQuaternionFromVector0:(GLKVector3)v0 toVector1:(GLKVector3)v1
{
    GLKVector3 sum = GLKVector3Add(v0, v1);
    if ((sum.x == 0) && (sum.y == 0) && (sum.z == 0)) {
        return GLKQuaternionMakeWithAngleAndVector3Axis(M_PI, GLKVector3Make(1, 0, 0));
    }
    
    GLKVector3 c = GLKVector3CrossProduct(v0, v1);
    float d = GLKVector3DotProduct(v0, v1);
    float s = sqrtf((1+d)*2);
    
    return GLKQuaternionMake(c.x/s, c.y/s, c.z/s, s/2.0f);
}

@end
