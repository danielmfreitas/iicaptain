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

- (id) init {
    if ((self = [super init])) {
        pathToFollow = [[IISmoothPath alloc]initWithMinimumLineLength:16];
        currentLineBeingFollowed = nil;
        speed = 32;
    }
    
    return self;
}

- (void) update: (ccTime) dt {
    
    if (currentLineBeingFollowed == nil) {
        if ([pathToFollow count] > 0) {
            currentLineBeingFollowed = [pathToFollow firstLine];
            [currentLineBeingFollowed retain];
            
            CGFloat angle = currentLineBeingFollowed.rotation - self.rotation;
            
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
    }

    if (currentLineBeingFollowed != nil) {
        CGFloat pixelsToMove = speed * dt;
        
        CGFloat remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(self.position.x, self.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
        
        if (pixelsToMove > remainingLength) {
            
            [pathToFollow removeFirstLine];
            IILine2D *nextLine = [pathToFollow firstLine];
            
            CGFloat remainingMovement = pixelsToMove - remainingLength;
            
            if (nextLine != nil) {
                                        
                // If a new line needs to be followed, first put rotation back to the 0-360 range so the calculations
                // do not screw up.
                if (self.rotation >= 360) {
                    self.rotation = self.rotation - 360;
                } else if (self.rotation <= -360) {
                    self.rotation = self.rotation + 360;
                }
                
                // Move directly to the end of the current line
                self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
                [currentLineBeingFollowed release];
                currentLineBeingFollowed = nextLine;
                [currentLineBeingFollowed retain];
                
                // Calculates the remainign length for the new line in path
                remainingLength = [IIMath2D lineLengthFromPoint:CGPointMake(self.position.x, self.position.y) toEndPoint:CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y)];
                CGFloat movementRatio = remainingMovement / remainingLength;
                
                CGFloat dX = (currentLineBeingFollowed.endPoint.x - self.position.x);
                CGFloat dY = (currentLineBeingFollowed.endPoint.y - self.position.y);
                
                CGFloat movementX = dX * movementRatio;
                CGFloat movementY = dY * movementRatio;
                
                self.position = CGPointMake(self.position.x + movementX, self.position.y + movementY);
                currentLineBeingFollowed.startPoint = CGPointMake(self.position.x, self.position.y);
                
                CGFloat angle = currentLineBeingFollowed.rotation - self.rotation;
                                    
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
            } else {
                self.position = CGPointMake(currentLineBeingFollowed.endPoint.x, currentLineBeingFollowed.endPoint.y);
                [pathToFollow removeFirstLine];
                currentLineBeingFollowed = nil;
            }
        } else {
            CGFloat movementRatio = pixelsToMove / remainingLength;
            
            CGFloat dX = (currentLineBeingFollowed.endPoint.x - self.position.x);
            CGFloat dY = (currentLineBeingFollowed.endPoint.y - self.position.y);
            
            CGFloat movementX = dX * movementRatio;
            CGFloat movementY = dY * movementRatio;
            
            self.position = CGPointMake(self.position.x + movementX, self.position.y + movementY);
            currentLineBeingFollowed.startPoint = CGPointMake(self.position.x, self.position.y);
        }
    }
}

- (void) stopMovement {
    currentLineBeingFollowed = nil;
}

-(void) dealloc {
    [pathToFollow release];
    [super dealloc];
}

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [[[self alloc] initWithTexture:texture rect:rect] autorelease];
}

@end
