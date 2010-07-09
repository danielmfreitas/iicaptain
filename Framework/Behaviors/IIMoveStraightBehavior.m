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

- (BOOL) doUpdate: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
        
    CGFloat pixelsToMoveThisFrame = theTarget.speed * timeElapsedSinceLastFrame;
    CGFloat angle = [IIMath2D radiansToDegrees:theTarget.rotation];
    
    // Make sure the shortest angle is obtained.
    if (angle < -180) {
        angle = angle +360;
    }
    
    if (angle > 180) {
        angle = angle - 360;
    }
    
    // Cast the angle in accordance with the trigonometric circle.
    angle = 90 - angle;
    
    // Change it to radians.
    angle = [IIMath2D degreesToRadians:angle];
    
    CGFloat dX = pixelsToMoveThisFrame * cos(angle);
    CGFloat dY = pixelsToMoveThisFrame * sin(angle);
    
    [theTarget moveByX:dX andY:dY];
    
    return YES;
}

@end
