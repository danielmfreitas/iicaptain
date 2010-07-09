//
//  IIBaseBehavioral.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBaseBehavioral.h"
#import "IIBehaviorProtocol.h"


@implementation IIBaseBehavioral

@synthesize speed;

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

- (CCAction*) runAction: (CCAction *) action {
    return nil;
}

- (CGFloat) rotation {
    return 0;
}

- (CGPoint) position {
    return CGPointZero;
}

- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd {
    [behaviors addObject: behaviorToAdd];
}

- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY {
    
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
