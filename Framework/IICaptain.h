//
//  IICaptain.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/CCSprite.h>
#import "IISmoothPath.h"
#import "IILine2D.h"

@interface IICaptain : CCSprite {
    IISmoothPath *pathToFollow;
    IILine2D *currentLineBeingFollowed;
    CGFloat speed;
    CGFloat rotateSpeed;
}

@property (nonatomic, readonly) IISmoothPath *pathToFollow;

- (void) update: (ccTime) dt;

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect;

@end
