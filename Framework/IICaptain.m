//
//  IICaptain.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/CCNode.h>
#import "IICaptain.h"
#import "IISmoothPath.h"

@implementation IICaptain

@synthesize pathToFollow;
@synthesize speed;

- (id) initWithNode: (CCNode *) aNode andPath: (IISmoothPath *) thePathToFollow {
    if ((self = [super initWithNode: aNode])) {
        pathToFollow = thePathToFollow;
        [pathToFollow retain];
        
        speed = 32;
    }
    
    return self;
}

-(void) dealloc {
    [pathToFollow release];
    [super dealloc];
}

@end
