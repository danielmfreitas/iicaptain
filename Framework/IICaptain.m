//
//  IICaptain.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IICaptain.h"
#import "IIStartOnNodeGestureFilter.h"

@implementation IICaptain

@synthesize pathToFollow;

- (void) handleDragGesture: (UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView: sender.view];
    point = [[CCDirector sharedDirector] convertToGL:point];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            point = self.position;
            [self stopMovement];
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

- (void) setManager:(IIGestureManager *) theManager {
    manager = theManager;
    IIStartOnNodeGestureFilter *filter = [[[IIStartOnNodeGestureFilter alloc] initWithNode: self] autorelease];
    [manager addTarget: self action: @selector(handleDragGesture:) toRecognizer: @"singleDragGesture" withFilter: filter];
    [manager retain];
}

- (id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager {
    if ((self = [super initWithTexture: texture rect: rect])) {
        [self setManager: theManager];
        pathToFollow = [[IISmoothPath alloc] initWithMinimumLineLength: 16];
        currentLineBeingFollowed = nil;
        speed = 32;
    }
    
    return self;
}

- (void) setCurrentLineBeingFollowed: (IILine2D *) theLine {
    if (currentLineBeingFollowed != theLine) {
        [currentLineBeingFollowed release];
        currentLineBeingFollowed = theLine;
        [currentLineBeingFollowed retain];
    }
}

- (void) rotateToLine: (IILine2D *) line {
    CGFloat angle = line.rotation - self.rotation;
            
    // Make sure the shortest angle is obtained.
    if (angle < -180) {
        angle = angle +360;
    }

    if (angle > 180) {
        angle = angle - 360;
    }

    // TODO Change hardcoded duration for rotation
    CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:0.5 angle:angle];
    [self runAction:rotateAction];
}

- (void) updatePosition: (CGFloat) pixelsToMove remainingLength: (CGFloat) remainingLength {
    
    CGFloat movementRatio = pixelsToMove / remainingLength;
            
    CGFloat dX = (currentLineBeingFollowed.endPoint.x - self.position.x);
    CGFloat dY = (currentLineBeingFollowed.endPoint.y - self.position.y);

    CGFloat movementX = dX * movementRatio;
    CGFloat movementY = dY * movementRatio;

    self.position = CGPointMake(self.position.x + movementX, self.position.y + movementY);
    currentLineBeingFollowed.startPoint = CGPointMake(self.position.x, self.position.y);
}

- (void) normalizeRotation {
    
    if (self.rotation >= 360) {
        self.rotation = self.rotation - 360;
    } else if (self.rotation <= -360) {
        self.rotation = self.rotation + 360;
    }
}

- (void) followCurrentLine: (ccTime) timeElapsedSinceLastFrame  {
    CGFloat pixelsToMoveThisFrame = speed * timeElapsedSinceLastFrame;
    CGFloat remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(self.position.x, self.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
    
    if (pixelsToMoveThisFrame <= remainingLength) {
        [self updatePosition: pixelsToMoveThisFrame remainingLength: remainingLength];
    } else {
        // If pixels to move > ramining length of current line, consumes pixels from the next lines until all pixels
        // are accounted or the path ends.
        while (pixelsToMoveThisFrame > remainingLength) {
            [pathToFollow removeFirstLine];
            
            if ([pathToFollow firstLine] != nil) {
                
                // If a new line needs to be followed, first put rotation back to the 0-360 range so the calculations
                // do not screw up.
                [self normalizeRotation];
                
                // Move directly to the end of the current line and get next line in path
                self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
                [self setCurrentLineBeingFollowed:[pathToFollow firstLine]];
                
                // Get the remaining pixels we still have to move on the new line
                pixelsToMoveThisFrame = pixelsToMoveThisFrame - remainingLength;
                
                // Calculates the remainign length on the new line in path
                remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(self.position.x, self.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
            } else {
                // If last line in path, just set final position to the end of the line.
                self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
                self.rotation = currentLineBeingFollowed.rotation;
                pixelsToMoveThisFrame = 0;
                remainingLength = 0;
                [pathToFollow removeFirstLine];
                [self setCurrentLineBeingFollowed:nil];
            }
        }
       
        // Move only if we still have pixels to move.
        if (pixelsToMoveThisFrame > 0) {
            [self updatePosition: pixelsToMoveThisFrame remainingLength: remainingLength];
            [self rotateToLine: currentLineBeingFollowed];
        }
    }
}

- (void) updateHeroMovement: (ccTime) timeElapsedSinceLastFrame  {
    if (currentLineBeingFollowed == nil) {
        if ([pathToFollow count] > 0) {
            [self setCurrentLineBeingFollowed:[pathToFollow firstLine]];
            [self rotateToLine: currentLineBeingFollowed];
        }
    }

    if (currentLineBeingFollowed != nil) {
        [self followCurrentLine: timeElapsedSinceLastFrame];
    }
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    
    [self updateHeroMovement: timeElapsedSinceLastFrame];
}

- (void) stopMovement {
    currentLineBeingFollowed = nil;
}

- (void) addPathToNode: (CCNode *) theNode {
    [theNode addChild: pathToFollow];
}

+(id) spriteWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager
{
	IICaptain *me = [[[self alloc] initWithTexture:texture rect:rect andManager: theManager] autorelease];
    me.manager = theManager;
    
    return me;
}

-(void) dealloc {
    [manager release];
    [pathToFollow release];
    [super dealloc];
}

@end
