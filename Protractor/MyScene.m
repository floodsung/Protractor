//
//  MyScene.m
//  Protractor
//
//  Created by FloodSurge on 7/31/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "MyScene.h"
#import "SRMotionDetector.h"


typedef enum{
    AngleMeasureStatusRestart = 0,
    AngleMeasureStatusConfirmFirstVector = 1,
    AngleMeasureStatusConfirmSecondVector = 2,
} AngleMeasureStatus;

@interface MyScene ()

@property (nonatomic,strong) SKSpriteNode *arrow1;
@property (nonatomic,strong) SKSpriteNode *arrow2;
@property (nonatomic,strong) SKLabelNode *angleLabel;
@property (nonatomic,strong) SKSpriteNode *circle;
@property (nonatomic,strong) SKSpriteNode *circleMask;

@property (nonatomic,strong) SRMotionDetector *motionDetector;


@end

@implementation MyScene
{
    AngleMeasureStatus measureStatus;
    
    float arrowInitScaleX;
    float arrowInitScaleY;
    float circleScale;
    float circleBackScale;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // basic initialization
        self.motionDetector = [SRMotionDetector sharedInstance];
        
        measureStatus = AngleMeasureStatusRestart;
        NSLog(@"init status:%d",measureStatus);
        
        
        
        
        /* Setup your scene here */
        
        int dice = arc4random()%5;
        
        switch (dice) {
            case 0:
                // blue
                self.backgroundColor = [SKColor colorWithRed:33.0f/255.0f green:177.0f/255.0f blue:210.0f/255.0f alpha:1];
                self.circleMask = [SKSpriteNode spriteNodeWithImageNamed:@"circleBlue"];
                break;
            case 1:
                // red
                self.backgroundColor = [SKColor colorWithRed:250.0f/255.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1];
                self.circleMask = [SKSpriteNode spriteNodeWithImageNamed:@"circleRed"];
                break;
            case 2:
                // Green
                self.backgroundColor = [SKColor colorWithRed:53.0f/255.0f green:187.0f/255.0f blue:8.0f/255.0f alpha:1];
                self.circleMask = [SKSpriteNode spriteNodeWithImageNamed:@"circleGreen"];
                break;
            case 3:
                // Orange
                self.backgroundColor = [SKColor colorWithRed:237.0f/255.0f green:138.0f/255.0f blue:41.0f/255.0f alpha:1];
                self.circleMask = [SKSpriteNode spriteNodeWithImageNamed:@"circleOrange"];
                break;
            case 4:
                // Black
                self.backgroundColor = [SKColor blackColor];
                self.circleMask = [SKSpriteNode spriteNodeWithImageNamed:@"circleBlack"];
                break;
                
                
            default:
                break;
        }
        
        
        
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            arrowInitScaleX = 0.8;
            arrowInitScaleY = 0.62;
            circleScale = 1;
            circleBackScale = 1;
        } else {
            arrowInitScaleX = 0.8 * 1.8;
            arrowInitScaleY = 0.62 * 1.8 ;
            circleScale = 1 * 1.8;
            circleBackScale = 1 * 1.8;
        }
        
        [self initSpriteNodes];
        
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch *anyTouch in touches) {
        CGPoint location = [anyTouch locationInNode:self];
        
        SKSpriteNode *touchNode = [SKSpriteNode spriteNodeWithImageNamed:@"Touch"];
        touchNode.position = location;
        touchNode.zPosition = 5;
        [touchNode setScale:0.5];
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
        SKAction *remove = [SKAction removeFromParent];
        
        [touchNode runAction:[SKAction sequence:@[fadeIn,fadeOut,remove]]];
        [self addChild:touchNode];
        
        
    }
    
    switch (measureStatus) {
        case AngleMeasureStatusRestart:
            measureStatus = AngleMeasureStatusConfirmFirstVector;
            self.arrow2.hidden = NO;
            self.circle.hidden = YES;
            
            
            [self.motionDetector confirmFirstVector];
            
            break;
        case AngleMeasureStatusConfirmFirstVector:
            measureStatus = AngleMeasureStatusConfirmSecondVector;
            [self.motionDetector confirmSecondVector];
            float angle = self.motionDetector.measureAngle;
            self.angleLabel.text = [NSString stringWithFormat:@"%3.1f˚",angle];
            self.circle.hidden = NO;
            [self animateArrowsToFinalPosition];
            
            break;
            
        case AngleMeasureStatusConfirmSecondVector:
            measureStatus = AngleMeasureStatusRestart;
            [self.motionDetector restartMeasure];
            self.angleLabel.text = @"0.0˚";
            self.arrow2.hidden = YES;
            self.circle.hidden = YES;
            
            break;
            
        default:
            break;
    }
    NSLog(@"status:%d",measureStatus);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    switch (measureStatus) {
        case AngleMeasureStatusRestart:
            self.arrow1.zRotation = self.motionDetector.rotation;
            self.arrow1.yScale = self.motionDetector.scale * arrowInitScaleY;
            self.circle.alpha = 0;
            break;
        case AngleMeasureStatusConfirmFirstVector:
            self.arrow2.zRotation = self.motionDetector.rotation;
            self.arrow2.yScale = self.motionDetector.scale * arrowInitScaleY;
            float angle = self.motionDetector.freeAngle;
            self.angleLabel.text = [NSString stringWithFormat:@"%3.1f˚",angle];
            self.circle.alpha = 0;
            break;
            
        default:
            break;
    }
    
    
}

- (void)initSpriteNodes
{
    self.arrow1 = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    self.arrow1.position = CGPointMake(self.size.width/2, self.size.height * 0.6);
    self.arrow1.anchorPoint = CGPointMake(0.5, 0.2);
    self.arrow1.yScale = arrowInitScaleY;
    self.arrow1.xScale = arrowInitScaleX;
    self.arrow1.zPosition = 2;
    [self addChild:self.arrow1];
    
    self.arrow2 = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    self.arrow2.position = CGPointMake(self.size.width/2, self.size.height * 0.6);
    self.arrow2.anchorPoint = CGPointMake(0.5, 0.2);
    self.arrow2.yScale = arrowInitScaleY;
    self.arrow2.xScale = arrowInitScaleX;
    self.arrow2.zPosition = 2;
    [self addChild:self.arrow2];
    self.arrow2.hidden = YES;
    
    // init angle label
    
    self.angleLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (self.size.height > 500) {
            self.angleLabel.position = CGPointMake(self.size.width/2, 120);
        } else {
            self.angleLabel.position = CGPointMake(self.size.width/2, 100);
        }
        
    } else {
        self.angleLabel.position = CGPointMake(self.size.width/2, 220);
        
    }
    
    self.angleLabel.fontSize = 50;
    self.angleLabel.fontColor = [SKColor whiteColor];
    self.angleLabel.text = @"0.0˚";
    [self addChild:self.angleLabel];
    
    self.circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
    self.circle.position = CGPointMake(self.size.width/2, self.size.height * 0.6);
    self.circle.anchorPoint = CGPointMake(0, 0.5);
    [self.circle setScale:circleScale];
    self.circle.zPosition = 0;
    self.circle.alpha = 0;
    [self addChild:self.circle];
    
    self.circleMask.position = CGPointMake(self.size.width/2, self.size.height * 0.6);
    self.circleMask.anchorPoint = CGPointMake(0, 0.5);
    self.circleMask.zPosition = 1;
    [self.circleMask setScale:circleBackScale];
    [self addChild:self.circleMask];
    
}

- (void)animateArrowsToFinalPosition
{
    [self.arrow1 runAction:[SKAction group:@[
                                             [SKAction scaleYTo:arrowInitScaleY duration:0.6],
                                             [SKAction rotateToAngle:0 duration:0.6]]]];
    [self.arrow2 runAction:[SKAction group:@[
                                             [SKAction scaleYTo:arrowInitScaleY duration:0.6],
                                             [SKAction rotateToAngle:-self.motionDetector.measureAngle/180.0*M_PI duration:0.6]]] completion:^{
        [self.circle runAction:[SKAction fadeInWithDuration:0.3]];
        self.circleMask.zRotation = -self.motionDetector.measureAngle/180.0*M_PI;
    }];
    
}


@end
