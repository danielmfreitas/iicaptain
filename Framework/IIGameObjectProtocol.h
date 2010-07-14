//
//  IIGameObject.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/ccTypes.h>
@class CCNode;

@protocol IIGameObjectProtocol

- (void) update: (ccTime) timeElapsedSinceLastFrame;
- (CCNode *) node;

@end
