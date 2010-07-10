//
//  IICaptain.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/CCSprite.h>
#import "IIBehavioralNode.h"

@class IISmoothPath;
@class IIGestureManager;

@interface IICaptain : IIBehavioralNode {
    IISmoothPath *pathToFollow;
    CGFloat speed;
    IIGestureManager *manager;
}

// TODO Remove this property once I figure out how to automatically add the pathToFollow to the parent view.
@property (nonatomic, readonly) IISmoothPath *pathToFollow;
@property (nonatomic, assign) CGFloat speed;

- (id) initWithNode: (CCNode *) aNode andManager: (IIGestureManager *) theManager;

- (void) addPathToNode: (CCNode *) theNode;

- (void) update: (ccTime) timeElapsedSinceLastFrame;

@end
