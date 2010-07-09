//
//  IIBehavioralNode.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBehavioralNode.h"
#import <cocos2d/CCNode.h>
#import "IIMath2D.h"

@implementation IIBehavioralNode

- (id) initWithNode: (CCNode *) aNode {
    if ((self = [super init])) {
        node = aNode;
        [node retain];
    }
    
    return self;
}

- (CGFloat) normalizeAngle: (CGFloat) angle  {
    // Normalize to (-360, 360). Have to use while as modulus only work on integer.
    while (angle >= 360) {
        angle = angle - 360;
    }
    
    while (angle <= -360) {
        angle = angle + 360;
    }
    
    return angle;
}

- (CGFloat) rotation {
    // Cast rotation to trigonometric coords.
    CGFloat rotation = 90 - node.rotation;
    rotation = [self normalizeAngle: rotation];
    
    return [IIMath2D degreesToRadians: rotation];
}

- (CGPoint) position {
    return node.position;
}

- (CCAction*) runAction: (CCAction *) action {
    return [node runAction: action];
}

- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY {
    node.position = CGPointMake(node.position.x + dX, node.position.y + dY);
}

- (void) rotateBy: (CGFloat) angle {
    // Calculate new node rotation.
    angle = [IIMath2D radiansToDegrees: angle];
    angle = node.rotation + angle;
    
    angle = [self normalizeAngle: angle];

    node.rotation = angle;
}

- (CGFloat) distanceToPoint: (CGPoint) destinationPoint {
    return [IIMath2D lineLengthFromPoint: CGPointMake(node.position.x, node.position.y) toEndPoint:destinationPoint];
}

- (CGFloat) distanceFromAngle: (CGFloat) destinationAngle {
    destinationAngle = [IIMath2D radiansToDegrees: destinationAngle];
    destinationAngle = [self normalizeAngle: destinationAngle];
    
    // Have to cast node rotation to trigonometric angles.
    CGFloat nodeAngle = [self normalizeAngle: 90 - node.rotation];
    
    CGFloat distance = destinationAngle - nodeAngle;
    distance = [self normalizeAngle: distance];
    
    // Make sure the shortest angle is obtained.
    if (distance < -180) {
        distance = distance +360;
    }
    
    if (distance > 180) {
        distance = distance - 360;
    }
    
    return [IIMath2D degreesToRadians: distance];
}

- (void) dealloc {
    [node release];
    
    [super dealloc];
}

@end
