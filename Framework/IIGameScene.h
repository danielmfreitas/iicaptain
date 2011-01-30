//
//  IIGameScene.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-13.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/CCScene.h>

@protocol IIGameObjectProtocol;
@class IIGestureManager;
@class CCLayer;

@interface IIGameScene : CCScene {
    CCLayer *gameLayer;
    IIGestureManager *gestureManager;
    NSMutableArray *gameObjects;
}

@property (nonatomic, readonly) CCLayer *gameLayer;
@property (nonatomic, readonly) IIGestureManager *gestureManager;

- (id) initWithGestureManager: (IIGestureManager *) theGestureManager;
- (void) addGameObject: (id<IIGameObjectProtocol>) aGameObject;
- (void) removeGameObject: (id<IIGameObjectProtocol>) theGameObject;

@end
