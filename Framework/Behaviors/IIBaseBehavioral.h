//
//  IIBaseBehavioral.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-08.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIGameObjectProtocol.h"
#import "IIBehavioralProtocol.h"


@interface IIBaseBehavioral : NSObject <IIGameObjectProtocol, IIBehavioralProtocol> {
    NSMutableArray *behaviors;
    CGFloat speed;
}

@property (nonatomic, assign) CGFloat speed;

@end
