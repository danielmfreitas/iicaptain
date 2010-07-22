//
//  IIDragTowardsNodeRotationGestureFilter.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-19.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIGestureManager.h"

@class CCNode;

@interface IIDragTowardsNodeRotationGestureFilter : NSObject <IIGestureFilter> {
    CCNode *targetNode;
    CGFloat angleTolerance;
    BOOL shouldAcceptInput;
}

- (id) initWithNode: (CCNode *) node andAngleTolerance: (CGFloat) theAngleTolerance;

@end
