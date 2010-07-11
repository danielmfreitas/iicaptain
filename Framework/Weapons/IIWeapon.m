//
//  IIWeapon.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIWeapon.h"
#import "IIBehavioralNodeProtocol.h"
#import "IIGestureManager.h"

@implementation IIWeapon

- (void) handleTapGesture: (UITapGestureRecognizer *) sender {
    NSLog(@"Tapped...");
    fired = YES;
}

- (id) initWithManager: (IIGestureManager *) theManager {
    if ((self = [super init])) {
        gestureManager = theManager;
        [gestureManager retain];
        
        [gestureManager addTarget: self action: @selector(handleTapGesture:) toRecognizer: @"singleTapGesture"];
    }
    
    return self;
}

- (BOOL) doUpdate: (id<IIBehavioralNodeProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    if (fired) {
        NSLog(@"Fired!");
        fired = NO;
        return YES;
    }
    
    return NO;
}

+ (IIWeapon *) initWithManager: (IIGestureManager *) theManager {
    IIWeapon *me = [[IIWeapon alloc] initWithManager: theManager];
    return [me autorelease];
}

- (void) dealloc {
    [gestureManager release];
    
    [super dealloc];
}

@end
