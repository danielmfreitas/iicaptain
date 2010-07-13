//
//  IIWeapon.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIWeapon.h"

@implementation IIWeapon

- (id) init {
    if ((self = [super init])) {
        state = STATE_IDLE;
    }
    
    return self;
}

- (void) fire {
    state = STATE_FIRING;
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    switch (state) {
        case STATE_IDLE:
            break;
        case STATE_FIRING:
            break;
        default:
            break;
    }
}

@end
