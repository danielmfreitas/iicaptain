//
//  IIBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <cocos2d/ccTypes.h>

@protocol IIBehavioralProtocol;

/**
 * A comportment that can be added to objects implementing the IIBehavioralProtocol.
 */
@protocol IIBehaviorProtocol <NSObject>

- (void) updateTarget: (id <IIBehavioralProtocol>) theTarget timeSinceLastFrame: (ccTime) timeElapsedSinceLastFrame;

- (BOOL) executed;

@end
