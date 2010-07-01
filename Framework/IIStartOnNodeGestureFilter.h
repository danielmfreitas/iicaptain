//
//  IIStartOnNodeGestureFilter.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-29.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/cocos2d.h>
#import "IIGestureManager.h"

@interface IIStartOnNodeGestureFilter : NSObject <IIGestureFilter>
{
    CCNode *targetNode;
    BOOL shouldAcceptInput;
    NSInteger widthTolerance;
    NSInteger heightTolerance;
}

- (id) initWithNode: (CCNode *) node;
- (id) initWithNode: (CCNode *) node widthTolerance: (NSInteger) theWTolerance andHeightTolerance: (NSInteger) theHTolerance;

@end
