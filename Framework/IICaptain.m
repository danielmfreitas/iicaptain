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
            
            CGFloat timeToMove = currentLineBeingFollowed.length / speed;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:timeToMove position:currentLineBeingFollowed.endPoint];
            [self runAction:moveTo];
            
            CGFloat angle = currentLineBeingFollowed.rotation - self.rotation;
            // TODO Change hardcoded duration for rotation
            CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:0.5 angle:angle];
            [self runAction:rotateAction];
        }
    } else {
        currentLineBeingFollowed.startPoint = self.position;
        if (self.position.x == currentLineBeingFollowed.endPoint.x
            && self.position.y == currentLineBeingFollowed.endPoint.y) {
            
            IILine2D *nextLine = [pathToFollow nextLine];
            
            if (nextLine != nil) {
                
                // If a new line needs to be followed, first put rotation back to the 0-360 range so the calculations
                // do not scre up.
                if (self.rotation >= 360) {
                    self.rotation = self.rotation - 360;
                } else if (self.rotation <= -360) {
                    self.rotation = self.rotation + 360;
                }
                
                currentLineBeingFollowed = nextLine;
                
                CGFloat timeToMove = currentLineBeingFollowed.length / speed;
                
                CCMoveTo *moveTo = [CCMoveTo actionWithDuration:timeToMove position:currentLineBeingFollowed.endPoint];
                [self runAction:moveTo];
                
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
    }

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
