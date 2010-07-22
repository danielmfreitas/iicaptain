//
//  IIDragTowardsNodeRotationGestureFilter.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-19.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIDragTowardsNodeRotationGestureFilter.h"
#import <cocos2d/cocos2d.h>
#import "IIMath2D.h"

@implementation IIDragTowardsNodeRotationGestureFilter

- (id) initWithNode: (CCNode *) node andAngleTolerance: (CGFloat) theAngleTolerance {
    if (([self init]) != nil) {
        targetNode = node;
        [targetNode retain];
        angleTolerance = theAngleTolerance;
        shouldAcceptInput = NO;
    }
    
    return self;
}

- (BOOL) isValidAngle: (CGFloat) angle toRotation: (CGFloat) nodeRotation {
    // 1 - Normaliza node rotation to ]-360, 360[
    nodeRotation = [IIMath2D normalizeDegrees:nodeRotation];
    
    // 2 - Cast CCNode rotation to trig circle ]-360, 360[
    CGFloat nodeDirection = 90 - nodeRotation;
    nodeDirection = [IIMath2D normalizeDegrees:nodeDirection];
    
    // 3 - Normalize node rotation to [0, 360[
    if (nodeDirection < 0) {
        nodeDirection = 360 + nodeDirection;
    }
    
    // 4 - Calculates acute angle between gesture angle and node rotation [180, -180[
    CGFloat difference = fabs(angle - nodeDirection);
    
    if (difference > 180) {
        difference = 360 - difference;
    }
    
    // 5 - Finally, if difference <= tolerance / 2, direction is valid
    if (difference <= angleTolerance / 2) {
        return YES;
    }
    
    return NO;
}

- (BOOL) acceptsEvent: (UIPanGestureRecognizer *) recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            // 1 - Get velocity on OpenGL view coordinate system.
            CGPoint velocityInView = [recognizer velocityInView: recognizer.view];
            velocityInView = [[CCDirector sharedDirector] convertToGL:velocityInView];    
            
            // 2 - Gets the cos of the angle. Gets hipotenuse by pitagoras and 3-rule x to get cos in range: [-1, 1].
            CGFloat h = sqrtf(velocityInView.x * velocityInView.x + velocityInView.y * velocityInView.y);
            CGFloat cos = velocityInView.x / h;
            
            CGFloat angle = 0;
            
            // 3 - Gets the angle using cosin (takes quadrant into account).
            if (velocityInView.x >= 0 && velocityInView.y >= 0) {
                angle = acosf(cos);
            } else if (velocityInView.x <= 0 && velocityInView.y >= 0) {
                angle = acosf(cos);
            } else if (velocityInView.x <= 0 && velocityInView.y <= 0) {
                angle = M_PI + (M_PI - acosf(cos));
            } else if (velocityInView.x >= 0 && velocityInView.y <= 0) {
                angle = 2 * M_PI - acosf(cos);
            }
            
            // 4 - Finally, transforms it to degrees and compare with target node rotation.
            angle = [IIMath2D radiansToDegrees:angle];
            
            if ([self isValidAngle: angle toRotation: targetNode.rotation]) {
                shouldAcceptInput = YES;
                return YES;
            }
            
            shouldAcceptInput = NO;
            return NO;
            
            break;
        }
        default:
            return shouldAcceptInput;
            break;
    }
}

- (void) dealloc {
    [targetNode release];
 
    [super dealloc];
}

@end
