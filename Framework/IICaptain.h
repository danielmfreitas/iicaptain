//
//  IICaptain.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBehavioralNode.h"

@class IISmoothPath;

@interface IICaptain : IIBehavioralNode {
    IISmoothPath *pathToFollow;
    CGFloat speed;
}

@property (nonatomic, readonly) IISmoothPath *pathToFollow;
@property (nonatomic, assign) CGFloat speed;

- (id) initWithNode: (CCNode *) aNode andPath: (IISmoothPath *) pathToFollow;

@end
