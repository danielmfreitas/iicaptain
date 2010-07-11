//
//  IIBehavioralNodeProtocol.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-09.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBehavioralProtocol.h"

@class CCAction;
@class CCNode;

@protocol IIBehavioralNodeProtocol <IIBehavioralProtocol>

/**
 * This behavioral node.
 */
- (CCNode *) node;

/**
 * Runs an action on the node.
 */
- (CCAction*) runAction: (CCAction *) action;

@end
