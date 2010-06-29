//
//  IICaptain.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IICaptain.h"

@implementation IICaptain

@synthesize pathToFollow;

- (void) handleDragGesture: (UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView: sender.view];
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            
            // Check the touch began in the hero sprite
            point = [[CCDirector sharedDirector] convertToGL:point];
            CGRect spriteBounds = CGRectMake(self.position.x - self.contentSize.width / 2,
                                             self.position.y - self.contentSize.height / 2,
                                             self.contentSize.width,
                                             self.contentSize.height);
            
            if (point.x >= spriteBounds.origin.x
                && point.x <= spriteBounds.origin.x + spriteBounds.size.width
                && point.y >= spriteBounds.origin.y &&
                point.y <= spriteBounds.origin.y + spriteBounds.size.height) {
                
                point = self.position;
                [self stopMovement];
                [pathToFollow clear];
                [pathToFollow startAcceptingInput];
                [pathToFollow processPoint:point];
            }
            break;
        case UIGestureRecognizerStateChanged:
            
            point = [[CCDirector sharedDirector] convertToGL:point];
            
            if (pathToFollow.acceptingInput) {
                [pathToFollow processPoint:point];
            }
            break;
        case UIGestureRecognizerStateEnded:
            
            if (pathToFollow.acceptingInput) {
                [pathToFollow stopAcceptingInput];
            }
            
            break;
        default:
            break;
    }
    
    NSLog(@"Captured gesture %i: (%f, %f).", sender.state, point.x, point.y);
}

- (void) setManager:(IIGestureManager *) theManager {
    manager = theManager;
    [manager addTarget: self action: @selector(handleDragGesture:) toRecognizer: @"singleDragGesture"];
    [manager retain];
}

-(id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager {
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
    
    if (pixelsToMoveThisFrame > remainingLength) {
        
        [pathToFollow removeFirstLine];
        
        if ([pathToFollow firstLine] != nil) {
            
            // If a new line needs to be followed, first put rotation back to the 0-360 range so the calculations
            // do not screw up.
            [self normalizeRotation];
            
            // Move directly to the end of the current line and get next line in path
            self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
            [self setCurrentLineBeingFollowed:[pathToFollow firstLine]];

            // Get the remaining pixels we still have to move on the new line
            CGFloat remainingPixelsToMove = pixelsToMoveThisFrame - remainingLength;

            // Calculates the remainign length on the new line in path
            remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(self.position.x, self.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
            [self updatePosition: remainingPixelsToMove remainingLength: remainingLength];
            [self rotateToLine: currentLineBeingFollowed];
        } else {
            // If last line in path, just set final position to the end of the line.
            self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
            [pathToFollow removeFirstLine];
            [self setCurrentLineBeingFollowed:nil];
        }
    } else {
        [self updatePosition: pixelsToMoveThisFrame remainingLength: remainingLength];
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

-(void) dealloc {
    [manager release];
    [pathToFollow release];
    [super dealloc];
}

+(id) spriteWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager
{
	IICaptain *me = [[[self alloc] initWithTexture:texture rect:rect andManager: theManager] autorelease];
    me.manager = theManager;
    
    return me;
}

@end
