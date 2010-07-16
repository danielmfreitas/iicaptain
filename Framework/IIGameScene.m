//
//  IIGameScene.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-13.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIGameScene.h"
#import "IIGestureManager.h"
#import <cocos2d/CCLayer.h>
#import "IIGameObjectProtocol.h"

@implementation IIGameScene

@synthesize gameLayer;
@synthesize gestureManager;
//iruu

- (id) initWithGestureManaget: (IIGestureManager *) theGestureManager {
    if ((self = [super init]) != nil) {
        gameLayer = [CCLayer node];
        [self addChild: gameLayer];
        [gameLayer retain];
        
        gestureManager = theGestureManager;
        [gestureManager retain];
        
        gameObjects = [[NSMutableArray alloc] init];
        
        [self schedule: @selector(update:)];
    }
    
    return self;
}

- (void) beforeUpdate: (ccTime) timeElapsedSinceLastFrame {
    
}

- (void) afterUpdate: (ccTime) timeElapsedSinceLastFrame {
    
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    [self beforeUpdate: timeElapsedSinceLastFrame];
    
    for (id<IIGameObjectProtocol> gameObject in gameObjects) {
        [gameObject update: timeElapsedSinceLastFrame];
    }
    
    [self afterUpdate: timeElapsedSinceLastFrame];
}

- (void) addGameObject: (id<IIGameObjectProtocol>) aGameObject {
    [gameObjects addObject: aGameObject];
}

- (void) removeGameObject: (id<IIGameObjectProtocol>) theGameObject {
    [gameObjects removeObject: theGameObject];
}

- (void) dealloc {
    [gameLayer release];
    [gestureManager release];
    [gameObjects release];
    
    [super dealloc];
}

@end
