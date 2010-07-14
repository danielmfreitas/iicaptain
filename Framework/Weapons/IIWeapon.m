//
//  IIWeapon.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIWeapon.h"
#import <cocos2d/cocos2d.h>
#import "IIMath2D.h"

@implementation IIWeapon

@synthesize state;
@synthesize weaponCooldown;
@synthesize remainingCooldown;

- (id) initWithNode: (CCNode *) theNode {
    if ((self = [super init])) {
        state = STATE_IDLE;
        node = theNode;
        [node retain];
    }
    
    return self;
}

- (void) fire {
    if (state == STATE_IDLE) {
        state = STATE_FIRING;
    }
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    switch (state) {
        case STATE_IDLE:
            break;
        case STATE_FIRING:
            if (projectile == nil) {
                projectile = [CCSprite spriteWithFile:@"cannonball.png"];
                [projectile retain];
                projectile.position = node.position;
                //TODO Give access to GameLayer instead of this.
                [node.parent.parent addChild: projectile];
            }
            
            state = STATE_COOLINGDOWN;
            break;
        case STATE_COOLINGDOWN:
            state = STATE_IDLE;
            break;
        default:
            break;
    }
    
    if (projectile != nil) {
        projectile.position = ccpAdd(projectile.position, CGPointMake(-1, 0));
        
        if ([IIMath2D lineLengthFromPoint: projectile.position toEndPoint: node.position] > 600) {
            //TODO Give access to GameLayer instead of this.
            [node.parent.parent removeChild: projectile cleanup:YES];
            [projectile release];
            projectile = nil;
        }
    }
}

- (void) dealloc {
    [node release];
    [projectile release];
    
    [super dealloc];
}

@end
