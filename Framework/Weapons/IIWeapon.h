//
//  IIWeapon.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/ccTypes.h>
#import "IIBehavioralNodeProtocol.h"

@class CCNode;
@class CCPointParticleSystem;
@class IIGameScene;
@class IIBehavioralNode;

typedef enum
{
    STATE_IDLE = 1,
    STATE_FIRING = 2,
    STATE_COOLINGDOWN = 4,
} WeaponState;

@interface IIWeapon : NSObject {
    WeaponState state;
    CGFloat weaponCooldown;
    CGFloat remainingCooldown;
    id <IIBehavioralNodeProtocol> behavioral;
    IIGameScene *scene;
    CCNode *projectile;
    CCPointParticleSystem *smoke1;
}

@property (nonatomic, readonly) WeaponState state;
@property (nonatomic, readonly) CGFloat weaponCooldown;
@property (nonatomic, readonly) CGFloat remainingCooldown;

- (id) initWithBehavioral: (id <IIBehavioralNodeProtocol>) theNode andScene: (IIGameScene *) theScene;
- (void) fire;
- (void) update: (ccTime) timeElapsedSinceLastFrame;

@end
