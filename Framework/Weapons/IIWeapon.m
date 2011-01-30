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
#import "IIGameScene.h"
#import "IIBehavioralNodeProtocol.h"

@implementation IIWeapon

@synthesize state;
@synthesize weaponCooldown;
@synthesize remainingCooldown;

- (id) initWithBehavioral: (id <IIBehavioralNodeProtocol>) theBehavioral andScene: (IIGameScene *) theScene {
    if ((self = [super init])) {
        state = STATE_IDLE;
        behavioral = theBehavioral;
        [behavioral retain];
        scene = theScene;
        [scene retain];
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
                projectile.position = ccp([behavioral position].x - [behavioral node].contentSize.width / 2, [behavioral position].y);

                smoke1 = [CCPointParticleSystem particleWithFile:@"cannon_shot.plist"];
                smoke1.position = [behavioral position];
                smoke1.angle = 180;
                smoke1.positionType = kPositionTypeFree;
                [smoke1 retain];

                [scene.gameLayer addChild: projectile];
                [scene.gameLayer addChild: smoke1];
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
		
        projectile.position = ccpAdd(projectile.position, CGPointMake(-3, 0));
        
        if ([IIMath2D lineLengthFromPoint: projectile.position toEndPoint: [behavioral position]] > 300) {
            [scene.gameLayer removeChild: projectile cleanup:YES];
            [scene.gameLayer removeChild: smoke1 cleanup:YES];
            [projectile release];
            [smoke1 release];
            projectile = nil;
            smoke1 = nil;
        }
    }
}

- (void) dealloc {
    [behavioral release];
    [scene release];
    [projectile release];
    
    [super dealloc];
}

@end
