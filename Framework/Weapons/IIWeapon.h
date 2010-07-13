//
//  IIWeapon.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/cocos2d.h>

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
}

@property (nonatomic, readonly) WeaponState state;
@property (nonatomic, readonly) CGFloat weaponCooldown;
@property (nonatomic, readonly) CGFloat remainingCooldown;

- (id) init;
- (void) fire;
- (void) update: (ccTime) timeElapsedSinceLastFrame;

@end
