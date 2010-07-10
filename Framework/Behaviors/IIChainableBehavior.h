//
//  IIChainableBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIBehaviorProtocol.h"


@interface IIChainableBehavior : NSObject <IIBehaviorProtocol> {
    IIChainableBehavior *requiredBehaviorToFail;
    id<IIBehaviorProtocol> nextBehavior;
    BOOL executed;
}

@property (nonatomic, readonly) BOOL executed;

- (void) requiresBehaviorToFail: (id <IIBehaviorProtocol>) theDependantBehavior;

@end
