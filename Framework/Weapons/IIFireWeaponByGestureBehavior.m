//
//  IIFireCannonByGestureBehavior.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-12.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIFireWeaponByGestureBehavior.h"
#import "IIGestureManager.h"
#import "IIBehavioralNode.h"

@implementation IIFireWeaponByGestureBehavior

- (void) handleTapGesture: (UITapGestureRecognizer *) sender {
    //CGPoint clickedPoint = [sender locationInView: sender.view];
    [weapon fire];
}

- (id) initWithManager: (IIGestureManager *) theManager
               gesture: (NSString *) gestureTag
             andWeapon: (IIWeapon *) theWeapon {
    
    if ((self = [super init])) {
        
        [theManager addTarget: self action: @selector(handleTapGesture:) toRecognizer: gestureTag];
        weapon = theWeapon;
        [weapon retain];
    }
    
    return self;
}

- (BOOL) doUpdate: (id<IIBehavioralNodeProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame {
    
    [weapon update: timeElapsedSinceLastFrame];
    
    return YES;
}

- (void) dealloc {
    [weapon release];
    
    [super dealloc];
}

@end
