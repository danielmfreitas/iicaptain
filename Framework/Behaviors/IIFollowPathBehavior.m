//
//  IIFollowPathBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIFollowPathBehavior.h"
#import <cocos2d/cocos2d.h>
#import "IISmoothPath.h"
#import "IIGestureManager.h"
#import "IIStartOnNodeGestureFilter.h"
#import "IIBehavioralNodeProtocol.h"
#import "IILine2D.h"
#import "HelloWorldScene.h"
#import "IICaptain.h"
#import "IIDragTowardsNodeRotationGestureFilter.h"

@implementation IIFollowPathBehavior

- (void) handleDragGesture: (UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView: sender.view];
    point = [[CCDirector sharedDirector] convertToGL:point];
    //TODO Provide a better way to access the game layer.
    point = [((HelloWorld *)[[CCDirector sharedDirector] runningScene]).gameLayer convertToNodeSpace: point];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [pathToFollow clear];
            [pathToFollow processPoint:point];
            break;
        case UIGestureRecognizerStateChanged:
            
            [pathToFollow processPoint:point];
            
            break;
        default:
            break;
    }
}

- (id) initWithSmoothPath: (IISmoothPath *) thePathToFollow {
    if ((self = [self init])) {
        pathToFollow = thePathToFollow;
        [pathToFollow retain];
    }
    
    return self;
}

- (id) initWithUpdatablePath: (IISmoothPath *) thePathToFollow
                      onNode: (CCNode *) theNode
           andGestureManager: (IIGestureManager *) theManager {
    return [self initWithUpdatablePath:thePathToFollow onNode:theNode withGestureManager:theManager andAllowedDirection:360];
}

- (id) initWithUpdatablePath: (IISmoothPath *) thePathToFollow
                      onNode: (CCNode *) theNode
           withGestureManager: (IIGestureManager *) theManager
           andAllowedDirection: (CGFloat) theAllowedDirection {
    if ((self = [self initWithSmoothPath: thePathToFollow])) {
        gestureManager = theManager;
        [gestureManager retain];
        
        targetNode = theNode;
        [targetNode retain];
        
        IIStartOnNodeGestureFilter *filter = [[[IIStartOnNodeGestureFilter alloc] initWithNode: theNode
                                                                                widthTolerance: 16
                                                                            andHeightTolerance: 0] autorelease];
        
        IIDragTowardsNodeRotationGestureFilter *directionFilter = [[[IIDragTowardsNodeRotationGestureFilter alloc]
                                                                    initWithNode: theNode
                                                                    andAngleTolerance: theAllowedDirection] autorelease];
        
        [gestureManager addTarget: self
                           action: @selector(handleDragGesture:)
                     toRecognizer: @"singleDragGesture"
                      withFilters: filter, directionFilter, nil];
    }
    
    return self;
}

- (void) rotateTarget: (id<IIBehavioralNodeProtocol>) theTarget toLine: (IILine2D *) line {
    CGFloat lineRotation = line.rotation;
    CGFloat angle = [theTarget distanceFromAngle: lineRotation];
    
    // TODO Change hardcoded duration for rotation
    CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:0.5 angle: angle];
    [theTarget runAction:rotateAction];
}

- (void) updateTargetPosition: (id <IIBehavioralProtocol>) theTarget by: (CGFloat) pixelsToMove
              remainingLength: (CGFloat) remainingLength alongLine: (IILine2D *) currentLineBeingFollowed {
    
    CGFloat movementRatio = pixelsToMove / remainingLength;
    
    CGFloat positionX = theTarget.position.x;
    CGFloat positionY = theTarget.position.y;
    
    CGFloat dX = (currentLineBeingFollowed.endPoint.x - positionX);
    CGFloat dY = (currentLineBeingFollowed.endPoint.y - positionY);
    
    CGFloat movementX = dX * movementRatio;
    CGFloat movementY = dY * movementRatio;
    
    [theTarget moveByX: movementX andY: movementY];
    CGPoint newPosition = CGPointMake(positionX + movementX, positionY + movementY);
    currentLineBeingFollowed.startPoint = newPosition;
}

- (void) moveTarget: (id<IIBehavioralNodeProtocol>) theTarget withTime: (ccTime) timeElapsedSinceLastFrame {
    IILine2D *currentLineBeingFollowed = [pathToFollow firstLine];
    
    CGFloat pixelsToMoveThisFrame = theTarget.speed * timeElapsedSinceLastFrame;
    CGFloat remainingLength = [theTarget distanceToPoint:CGPointMake(currentLineBeingFollowed.endPoint.x,
                                                                     currentLineBeingFollowed.endPoint.y)];
    
    if (pixelsToMoveThisFrame <= remainingLength) {
        [self updateTargetPosition: theTarget by: pixelsToMoveThisFrame remainingLength: remainingLength
                         alongLine: currentLineBeingFollowed];
    } else {
        // If pixels to move > ramining length of current line, consumes pixels from the next lines until all pixels
        // are accounted or the path ends.
        while (pixelsToMoveThisFrame > remainingLength) {
            
            CGFloat toLineEndX = currentLineBeingFollowed.endPoint.x - theTarget.position.x;
            CGFloat toLineEndY = currentLineBeingFollowed.endPoint.y - theTarget.position.y;
            
            if ([pathToFollow count] > 1) {
                // Move directly to the end of the current line and get next line in path
                [theTarget moveByX:toLineEndX andY:toLineEndY];
                [pathToFollow removeFirstLine];
                currentLineBeingFollowed = [pathToFollow firstLine];
                
                // Get the remaining pixels we still have to move on the new line
                pixelsToMoveThisFrame = pixelsToMoveThisFrame - remainingLength;
                
                // Calculates the remainign length on the new line in path
                remainingLength = [theTarget distanceToPoint:CGPointMake(currentLineBeingFollowed.endPoint.x,
                                                                         currentLineBeingFollowed.endPoint.y)];
            } else {
                // If last line in path, just set final position to the end of the line.
                [theTarget moveByX:toLineEndX andY:toLineEndY];
                pixelsToMoveThisFrame = 0;
                remainingLength = 0;
                [pathToFollow removeFirstLine];
            }
        }
        
        // Move only if we still have pixels to move.
        if (pixelsToMoveThisFrame > 0) {
            [self updateTargetPosition: theTarget by: pixelsToMoveThisFrame remainingLength: remainingLength
                             alongLine: currentLineBeingFollowed];
            [self rotateTarget: theTarget toLine: currentLineBeingFollowed];
        }
    }
}

- (BOOL) doUpdate: (id<IIBehavioralNodeProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    
    // Static local variable to check if the path was empty in the previous loop
    // TODO If we remove the rotateBy action and actually calculate the rotation based on the position in the line,
    // we can remove this check as the moveTarget will always calculate and update the rotation.
    static BOOL wasEmpty = YES;
    IILine2D *currentLine = [pathToFollow firstLine];
    
    if (currentLine != nil) {
        if (wasEmpty) {
            // If it was empty before, the this is the first line. Needs to rotate to the first line.
            // Set the line start point to ship coords in case the ship moved since the start point was captured.
            currentLine.startPoint = CGPointMake(theTarget.position.x, theTarget.position.y);
            [self rotateTarget: theTarget toLine: currentLine];
            wasEmpty = NO;
        }
        
        [self moveTarget: theTarget withTime: timeElapsedSinceLastFrame];
        return YES;
    } else {
        wasEmpty = YES;
        return NO;
    }
}

- (void) dealloc {
    [pathToFollow release];
    [targetNode release];
    [gestureManager release];
    [super dealloc];
}

@end
