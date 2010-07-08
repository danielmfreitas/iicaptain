//
//  IIBasicBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-07.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBehaviorProtocol.h"


@interface IIBasicBehavior : NSObject <IIBehaviorProtocol> {
    id<IIBehaviorProtocol> dependantBehavior;
    BOOL executed;
}

@end
