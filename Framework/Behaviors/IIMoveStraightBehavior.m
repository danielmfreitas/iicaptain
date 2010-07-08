//
//  IIMoveStraightBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-07.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIMoveStraightBehavior.h"
#import "IIBehavioralProtocol.h"
#import "IIMath2D.h"

@implementation IIMoveStraightBehavior

- (void) updateTarget: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    
    //First, check if dependant behavior failed to execute. If there's no dependant behavior, than nil evaluates
    //to FALSE, making this behavior execute.
    if ([dependantBehavior executed]) {
        return;
    }
    
    CGFloat pixelsToMoveThisFrame = theTarget.speed * timeElapsedSinceLastFrame;
    CGFloat angle = theTarget.rotation;
    
    // Make sure the shortest angle is obtained.
    if (angle < -180) {
        angle = angle +360;
    }
    
    if (angle > 180) {
        angle = angle - 360;
    }
    
    // Cast the angle in accordance with the trigonometric circle.
    angle = 90 - theTarget.rotation;
    
    // Change it to radians.
    angle = [IIMath2D degreesToRadians:angle];
    
    CGFloat dX = pixelsToMoveThisFrame * cos(angle);
    CGFloat dY = pixelsToMoveThisFrame * sin(angle);
    
    theTarget.position = CGPointMake(theTarget.position.x + dX, theTarget.position.y + dY);
    
    executed = YES;
}

@end
