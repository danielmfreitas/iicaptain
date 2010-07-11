//
//  IIWeapon.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-10.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIChainableBehavior.h"

@class IIGestureManager;

@interface IIWeapon : IIChainableBehavior {
    IIGestureManager *gestureManager;
    BOOL fired;
}

+ (IIWeapon *) initWithManager: (IIGestureManager *) theManager;

@end
