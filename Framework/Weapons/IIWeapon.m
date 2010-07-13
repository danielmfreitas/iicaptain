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
#import <cocos2d/cocos2d.h>

@implementation IIWeapon

//Note: Weapon cannot be a behavior. The behavior to shoot 
- (void) handleTapGesture: (UITapGestureRecognizer *) sender {
    // Have to use CCDirector openGLView since Tap gesture recognizer always return (0,0) for the position on the window.
    // Is this a bug in UITapGestureRecognizer (other recognizers works just fine with window).
    CGPoint clickedPoint = [sender locationInView: sender.view];
    fired = YES;
}

- (id) initWithManager: (IIGestureManager *) theManager {
    if ((self = [super init])) {
        gestureManager = theManager;
        [gestureManager retain];
        
        [gestureManager addTarget: self action: @selector(handleTapGesture:) toRecognizer: @"singleTapGesture"];
        
        cannonBall = [CCSprite spriteWithFile:@"cannonBall.png"];
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
    [cannonBall release];
    
    [super dealloc];
}

@end
