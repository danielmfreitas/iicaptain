//
//  IIBaseBehavioral.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/ccTypes.h>
#import "IIBaseBehavioral.h"
#import "IIBehaviorProtocol.h"


@implementation IIBaseBehavioral

- (id) init {
    if ((self = [super init])) {
        behaviors = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) beforeBehaviors {
    
}

- (void) afterBehaviors {
    
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    [self beforeBehaviors];
    
    for (id<IIBehaviorProtocol> behavior in behaviors) {
        [behavior updateTarget: self timeSinceLastFrame: timeElapsedSinceLastFrame];
    }
    
    [self afterBehaviors];
}

- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd {
    [behaviors addObject: behaviorToAdd];
}

- (CGFloat) speed {
    return 0;
}

- (void) setSpeed: (CGFloat) theSpeed {
    
}

- (CGPoint) position {
    return CGPointZero;
}

- (void) setPosition: (CGPoint) newPosition {
    
}

- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY {
    
}

- (CGFloat) rotation {
    return 0;
}

- (void) setRotation: (CGFloat) newRotation {
    
}

- (void) rotateBy: (CGFloat) angle {
    
}

- (CGFloat) distanceToPoint: (CGPoint) destinationPoint {
    return 0;
}

- (CGFloat) distanceFromAngle: (CGFloat) destinationAngle {
    return destinationAngle;
}

- (void) dealloc {
    [behaviors release];
    
    [super dealloc];
}

@end
