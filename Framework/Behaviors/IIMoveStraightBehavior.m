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
    
    CGFloat angle = theTarget.rotation;
    
    CGFloat dX = pixelsToMoveThisFrame * cos(angle);
    CGFloat dY = pixelsToMoveThisFrame * sin(angle);
    
    [theTarget moveByX:dX andY:dY];
    
    return YES;
}

@end
