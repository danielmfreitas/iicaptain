//
//  IIChainableBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIChainableBehavior.h"


@implementation IIChainableBehavior

- (id) init {
    if ((self = [super init])) {
        executed = NO;
    }
    
    return self;
}

- (BOOL) doUpdate: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    return YES;
}

- (void) updateTarget: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    if (![requiredBehaviorToFail executed]) {
        executed = [self doUpdate: theTarget timeSinceLastFrame: timeElapsedSinceLastFrame];
    } else {
        executed = NO;
    }
}

- (void) requiresBehaviorToFail: (id <IIBehaviorProtocol>) theDependantBehavior {
    if (requiredBehaviorToFail != theDependantBehavior) {
        [requiredBehaviorToFail release];
        requiredBehaviorToFail = theDependantBehavior;
        [requiredBehaviorToFail retain];
    }
}

- (BOOL) executed {
    return executed;
}

- (void) dealloc {
    [requiredBehaviorToFail release];
    
    [super dealloc];
}

@end
