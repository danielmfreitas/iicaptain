//
//  IIBasicBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-07.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBasicBehavior.h"

// TODO Create a template method for the basic behavior to automatically check for dependantBehavior.
// Make children classes implement another update that will only be executed if dependant does not execute.
// This avoids the logic to be duplicated on every behavior.
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
