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
        rotateSpeed = 90;
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
        }
    } else {
        currentLineBeingFollowed.startPoint = self.position;
        if (self.position.x == currentLineBeingFollowed.endPoint.x
            && self.position.y == currentLineBeingFollowed.endPoint.y) {
            
            IILine2D *nextLine = [pathToFollow nextLine];
            
            if (nextLine != nil) {
                currentLineBeingFollowed = nextLine;
                
                CGFloat timeToMove = currentLineBeingFollowed.length / speed;
                
                CCMoveTo *moveTo = [CCMoveTo actionWithDuration:timeToMove position:currentLineBeingFollowed.endPoint];
                [self runAction:moveTo];
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
