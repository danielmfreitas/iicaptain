//
//  IIBehavioralNode.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIBaseBehavioral.h"

@class CCNode;

@interface IIBehavioralNode : IIBaseBehavioral {
    CCNode *node;
}

- (id) initWithNode: (CCNode *) aNode;

@end
