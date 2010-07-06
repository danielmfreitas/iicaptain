//
//  IIFollowPathBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/cocos2d.h>
#import "IILine2D.h"
#import "IIBehaviorProtocol.h"
#import "IIBehavioralProtocol.h"
#import "IIFollowPathBehavior.h"
#import "IIMath2D.h"
#import "IISmoothPath.h"

@implementation IIFollowPathBehavior

- (IIFollowPathBehavior *) init {
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (IIFollowPathBehavior *) initWithSmoothPath: (IISmoothPath *) thePathToFollow {
    if ((self = [self init])) {
        pathToFollow = thePathToFollow;
        [pathToFollow retain];
    }
    
    return self;
}

- (void) followNewPath: (IISmoothPath *) theNewPath {
    if (pathToFollow != theNewPath) {
        [pathToFollow release];
        pathToFollow = theNewPath;
        [pathToFollow retain];
    }
}

- (void) setCurrentLineBeingFollowed: (IILine2D *) theLine {
    if (currentLineBeingFollowed != theLine) {
        [currentLineBeingFollowed release];
        currentLineBeingFollowed = theLine;
        [currentLineBeingFollowed retain];
    }
}

- (void) rotateTarget: (id <IIBehavioralProtocol>) theTarget toLine: (IILine2D *) line {
    CGFloat angle = line.rotation - theTarget.rotation;
    
    // Make sure the shortest angle is obtained.
    if (angle < -180) {
        angle = angle +360;
    }
    
    if (angle > 180) {
        angle = angle - 360;
    }
    
    // TODO Change hardcoded duration for rotation
    CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:0.5 angle:angle];
    [theTarget runAction:rotateAction];
}

- (void) updateTargetPosition: (id <IIBehavioralProtocol>) theTarget by: (CGFloat) pixelsToMove remainingLength: (CGFloat) remainingLength {
    
    CGFloat movementRatio = pixelsToMove / remainingLength;
    
    CGFloat positionX = theTarget.position.x;
    CGFloat positionY = theTarget.position.y;
    
    CGFloat dX = (currentLineBeingFollowed.endPoint.x - positionX);
    CGFloat dY = (currentLineBeingFollowed.endPoint.y - positionY);
    
    CGFloat movementX = dX * movementRatio;
    CGFloat movementY = dY * movementRatio;
    
    CGPoint newPosition = CGPointMake(positionX + movementX, positionY + movementY);
    
    theTarget.position = newPosition;
    currentLineBeingFollowed.startPoint = newPosition;
}

- (void) normalizeTargetRotation: (id <IIBehavioralProtocol>) theTarget {
    
    CGFloat rotation = theTarget.rotation;
    
    if (rotation >= 360) {
        theTarget.rotation = rotation - 360;
    } else if (rotation <= -360) {
        theTarget.rotation = rotation + 360;
    }
}

- (void) moveTarget: (id <IIBehavioralProtocol>) theTarget withTime: (ccTime) timeElapsedSinceLastFrame  {
    CGFloat pixelsToMoveThisFrame = theTarget.speed * timeElapsedSinceLastFrame;
    CGFloat remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(theTarget.position.x, theTarget.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
    
    if (pixelsToMoveThisFrame <= remainingLength) {
        [self updateTargetPosition: theTarget by: pixelsToMoveThisFrame remainingLength: remainingLength];
    } else {
        // If pixels to move > ramining length of current line, consumes pixels from the next lines until all pixels
        // are accounted or the path ends.
        while (pixelsToMoveThisFrame > remainingLength) {
            [pathToFollow removeFirstLine];
            
            if ([pathToFollow firstLine] != nil) {
                
                // If a new line needs to be followed, first put rotation back to the 0-360 range so the calculations
                // do not screw up.
                [self normalizeTargetRotation: theTarget];
                
                // Move directly to the end of the current line and get next line in path
                theTarget.position = CGPointMake(currentLineBeingFollowed.endPoint.x,
                                                    currentLineBeingFollowed.endPoint.y);
                [self setCurrentLineBeingFollowed:[pathToFollow firstLine]];
                
                // Get the remaining pixels we still have to move on the new line
                pixelsToMoveThisFrame = pixelsToMoveThisFrame - remainingLength;
                
                // Calculates the remainign length on the new line in path
                remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(theTarget.position.x,
                                                                            theTarget.position.y)
                                                     toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x,
                                                                            currentLineBeingFollowed.endPoint.y)];
            } else {
                // If last line in path, just set final position to the end of the line.
                theTarget.position = CGPointMake(currentLineBeingFollowed.endPoint.x,
                                                currentLineBeingFollowed.endPoint.y);
                theTarget.rotation = currentLineBeingFollowed.rotation;
                pixelsToMoveThisFrame = 0;
                remainingLength = 0;
                [pathToFollow removeFirstLine];
                [self setCurrentLineBeingFollowed:nil];
            }
        }
        
        // Move only if we still have pixels to move.
        if (pixelsToMoveThisFrame > 0) {
            [self updateTargetPosition: theTarget by: pixelsToMoveThisFrame remainingLength: remainingLength];
            [self rotateTarget: theTarget toLine: currentLineBeingFollowed];
        }
    }
}

- (void) updateTarget: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    if (currentLineBeingFollowed == nil) {
        if ([pathToFollow count] > 0) {
            [self setCurrentLineBeingFollowed:[pathToFollow firstLine]];
            [self rotateTarget: theTarget toLine: currentLineBeingFollowed];
        }
    }
    
    if (currentLineBeingFollowed != nil) {
        [self moveTarget: theTarget withTime: timeElapsedSinceLastFrame];
    }
}

- (void) dealloc {
    [pathToFollow release];
    
    [super dealloc];
}

@end
