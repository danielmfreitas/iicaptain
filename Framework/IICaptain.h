//
//  IICaptain.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/CCSprite.h>
#import "IIBehavioralProtocol.h"

@class IISmoothPath;
@class IIGestureManager;

@interface IICaptain : CCSprite <IIBehavioralProtocol> {
    IISmoothPath *pathToFollow;
    CGFloat speed;
    CGFloat rotateSpeed;
    IIGestureManager *manager;
    NSMutableArray *behaviors;
}

@property (nonatomic, assign) CGFloat speed;

// TODO Remove this property once I figure out how to automatically add the pathToFollow to the parent view.
@property (nonatomic, readonly) IISmoothPath *pathToFollow;

- (id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager;

- (void) addPathToNode: (CCNode *) theNode;

- (void) update: (ccTime) timeElapsedSinceLastFrame;

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect andManager: (IIGestureManager *) theManager;

@end
