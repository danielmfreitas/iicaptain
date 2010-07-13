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
    STATE_IDLE = 0,
    STATE_COOLINGDOWN = 1,
    STATE_FIRING = 2
} WeaponState;

@interface IIWeapon : NSObject {
    WeaponState state;
}

- (id) init;
- (void) fire;
- (void) update: (ccTime) timeElapsedSinceLastFrame;

@end
