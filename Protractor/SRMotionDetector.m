//
//  SRMotionDetector.m
//  Polliwog
//
//  Created by Rotek on 7/14.
//  Copyright (c) 2014 Rotek. All rights reserved.
//

#import "SRMotionDetector.h"
#import "SRMath.h"
  
@interface SRMotionDetector ()

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign,readwrite) float rotation;
@property (nonatomic,assign,readwrite) float scale;
@property (nonatomic,assign,readwrite) float measureAngle;
@property (nonatomic,assign,readwrite) float freeAngle;

@end

@implementation SRMotionDetector
{
    GLKQuaternion line1;
    GLKQuaternion line2;
}

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static SRMotionDetector *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Private Methods

- (id)init
{
    if (self = [super init]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.01f;
        self.scale = 0.0f;
        self.rotation = 0.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmFirstVector) name:@"AngleMeasureConfirmFirstVector" object:nil];
    }
    
    return self;
}

- (void)startUpdate
{
    NSLog(@"start update");
    if (self.motionManager.isDeviceMotionAvailable) {
        if (!self.motionManager.isDeviceMotionActive) {
            [self.motionManager startDeviceMotionUpdates];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(dataAnalyse) userInfo:nil repeats:YES];
            NSLog(@"Start device motion");
        }
    } else NSLog(@"Device motion unavailable");
    
}

- (void)stopUpdate
{
    NSLog(@"stop Update");
    if (self.motionManager.isDeviceMotionAvailable) {
        if (self.motionManager.isDeviceMotionActive) {
            [self.motionManager stopDeviceMotionUpdates];
            [self.timer invalidate];
            NSLog(@"Stop device motion");
        }
    } else NSLog(@"Device motion unavailable");
}


- (void)reset
{
    [self stopUpdate];
    [self startUpdate];
}

- (void)dataAnalyse
{
    // 1 Obtain the current attitude and turn it into quaternion.
    // 1 获取设备的姿态并转换为Quaternion
    GLKQuaternion currentAttitude = GLKQuaternionMake(self.motionManager.deviceMotion.attitude.quaternion.x, self.motionManager.deviceMotion.attitude.quaternion.y, self.motionManager.deviceMotion.attitude.quaternion.z, self.motionManager.deviceMotion.attitude.quaternion.w);
    
    // 2 Translate the quaternion into Vector to obtain the side line vector3 of device
    // 2 通过变换计算出设备的侧边在初始坐标系的向量值
    // 2 计算方法：因为设备向前的向量是(0,1,0),通过计算这个向量绕姿态旋转得到的向量来获取当前设备侧边的向量
    GLKVector3 initVector3 = GLKVector3Make(0, 1, 0);
    GLKVector3 currentVector3 = GLKQuaternionRotateVector3(currentAttitude, initVector3);
    
    
    // 3 计算设备侧边向量在x，y轴上的投影并计算其单位化向量
    GLKVector3 projectionVector3OnXandY = GLKVector3Make(currentVector3.x, currentVector3.y, 0);
    
    //NSLog(@"x:%f,y:%f",projectionVector3OnXandY.x,projectionVector3OnXandY.y);
    self.scale = sqrtf(projectionVector3OnXandY.x * projectionVector3OnXandY.x + projectionVector3OnXandY.y * projectionVector3OnXandY.y);
    
    GLKVector3 normalProjectionVector3 = GLKVector3Normalize(projectionVector3OnXandY);
    
    // 4 计算从这个投影向量到初始向量的Quaternion
    GLKQuaternion theta = [SRMath createQuaternionFromVector0:normalProjectionVector3 toVector1:initVector3];
    
    // 5 计算出当前设备姿态绕屏幕旋转的角度，其实就是计算投影向量与初始向量的夹角。并规定正负值。
    GLKVector3 relativeEnd = GLKQuaternionRotateVector3(theta, initVector3);
    
    if (relativeEnd.x >= 0) {
        self.rotation =  GLKQuaternionAngle(theta);
    } else {
        self.rotation = - GLKQuaternionAngle(theta);
    }
    
    
    line2 = currentAttitude;
    // Step 1: use (0,1,0) to calculate the vector3
    GLKVector3 start = GLKVector3Make(0, 1, 0);
    GLKVector3 end0 = GLKQuaternionRotateVector3(line1, start);
    GLKVector3 end1 = GLKQuaternionRotateVector3(line2, start);
    
    // Step 2: calculate quaternion from end0 to end1
    GLKQuaternion theta2 = [SRMath createQuaternionFromVector0:end0 toVector1:end1];
    
    // Judge the angle clockwise or counterclockwise,clockwise is positive
    // Since theta is calculated from end1 to end0,so below do the if statement in negative way.
    GLKVector3 relativeEnd2 = GLKQuaternionRotateVector3(theta2, start);
    if (relativeEnd2.x >= 0) {
        self.freeAngle = GLKQuaternionAngle(theta2) * 180.0 / M_PI;
    } else {
        self.freeAngle = -GLKQuaternionAngle(theta2) * 180.0 / M_PI;
    }

}

- (void)confirmFirstVector
{
    NSLog(@"confirm first vector");
    line1 = GLKQuaternionMake(self.motionManager.deviceMotion.attitude.quaternion.x, self.motionManager.deviceMotion.attitude.quaternion.y, self.motionManager.deviceMotion.attitude.quaternion.z, self.motionManager.deviceMotion.attitude.quaternion.w);
    
    

    
}

- (void)confirmSecondVector
{
    self.measureAngle = self.freeAngle;
}

- (void)restartMeasure
{
    line1 = GLKQuaternionMake(0, 0, 0, 0);
    line2 = GLKQuaternionMake(0, 0, 0, 0);
    
}


@end
