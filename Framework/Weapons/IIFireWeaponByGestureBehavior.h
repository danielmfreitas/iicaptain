//
//  IIFireCannonByGestureBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-12.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIChainableBehavior.h"

@class IIWeapon;
@class IIGestureManager;

@interface IIFireWeaponByGestureBehavior : IIChainableBehavior {
    IIWeapon *weapon;
}

- (id) initWithManager: (IIGestureManager *) theManager
               gesture: (NSString *) gestureTag
             andWeapon: (IIWeapon *) theWeapon;

@end
