//
//  IIWeapon.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIChainableBehavior.h"

@class IIGestureManager;
@class CCSprite;

@interface IIWeapon : IIChainableBehavior {
    IIGestureManager *gestureManager;
    BOOL fired;
    CCSprite *cannonBall;
}

+ (IIWeapon *) initWithManager: (IIGestureManager *) theManager;

@end
