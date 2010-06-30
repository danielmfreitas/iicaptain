//
//  IICaptain.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/CCSprite.h>
#import "IISmoothPath.h"
#import "IILine2D.h"
#import "IIMath2D.h"
#import "IIGestureManager.h"

@interface IICaptain : CCSprite {
    IISmoothPath *pathToFollow;
    IILine2D *currentLineBeingFollowed;
    CGFloat speed;
    CGFloat rotateSpeed;
    IIGestureManager *manager;
}

// TODO Remove this property once I figure out how to automatically add the pathToFollow to the parent view.
@property (nonatomic, readonly) IISmoothPath *pathToFollow;

- (id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager;

- (void) addPathToNode: (CCNode *) theNode;

- (void) update: (ccTime) timeElapsedSinceLastFrame;
// TODO Temporary hack to stop movement if path changes while last path is not complete.
- (void) stopMovement;

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect andManager: (IIGestureManager *) theManager;

@end
