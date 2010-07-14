//
//  IIBehavioralNode.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/CCNode.h>
#import "IIBehaviorProtocol.h"
#import "IIBehavioralNode.h"
#import "IIMath2D.h"

@implementation IIBehavioralNode

@synthesize node;

- (id) initWithNode: (CCNode *) aNode {
    if ((self = [super init])) {
        node = aNode;
        [node retain];
        
        behaviors = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd {
    [behaviors addObject: behaviorToAdd];
}

- (CGFloat) speed {
    return 0;
}

- (void) setSpeed: (CGFloat) theSpeed {
    
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

- (CGFloat) normalizeAngle: (CGFloat) angle  {
    // Normalize to (-360, 360). Have to use while loop as modulus only work on integer.
    while (angle >= 360) {
        angle = angle - 360;
    }
    
    while (angle <= -360) {
        angle = angle + 360;
    }
    
    return angle;
}

- (CGPoint) position {
    return node.position;
}

- (void) setPosition: (CGPoint) newPosition {
    node.position = newPosition;
}

- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY {
    node.position = CGPointMake(node.position.x + dX, node.position.y + dY);
}

- (CGFloat) rotation {
    return node.rotation;
}

- (void) setRotation: (CGFloat) newRotation {
    node.rotation = newRotation;
}


- (void) rotateBy: (CGFloat) angle {
        // Calculate new node rotation.
    angle = node.rotation + angle;
    angle = [self normalizeAngle: angle];
    
    node.rotation = angle;
}

- (CGFloat) distanceToPoint: (CGPoint) destinationPoint {
    return [IIMath2D lineLengthFromPoint: CGPointMake(node.position.x, node.position.y) toEndPoint:destinationPoint];
}

- (CGFloat) distanceFromAngle: (CGFloat) destinationAngle {
    CGFloat destAngle = [self normalizeAngle: destinationAngle];
    CGFloat nodeAngle = [self normalizeAngle: node.rotation];
    
    CGFloat distance = destAngle - nodeAngle;
    distance = [self normalizeAngle: distance];
    
    // Make sure the shortest angle is obtained.
    if (distance < -180) {
        distance = distance +360;
    }
    
    if (distance > 180) {
        distance = distance - 360;
    }
    
    return distance;
}

- (CCAction*) runAction: (CCAction *) action {
    return [node runAction: action];
}


- (void) dealloc {
    [behaviors release];
    [node release];
    
    [super dealloc];
}

@end
