//
//  IIBasicBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-07.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBasicBehavior.h"


@implementation IIBasicBehavior

- (void) updateTarget: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    executed = YES;
}

- (void) requiresBehaviorToFail: (id <IIBehaviorProtocol>) theDependantBehavior {
    if (dependantBehavior != theDependantBehavior) {
        [dependantBehavior release];
        dependantBehavior = theDependantBehavior;
        [dependantBehavior retain];
    }
}

- (BOOL) executed {
    return executed;
}

- (void) dealloc {
    [dependantBehavior release];
    
    [super dealloc];
}

@end
