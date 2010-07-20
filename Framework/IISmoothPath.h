//
//  SmoothPath.h
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-12.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocos2d/cocos2d.h>

@class IILine2D;


@interface IISmoothPath : CCNode {
    NSMutableArray* linesInPath;
    CGFloat minimumLineLength;
    CGFloat angleThreshold;
    CGFloat minimumAllowedAngle;
    CGFloat maximumPathLength;
    BOOL acceptingInput;
}

@property (nonatomic, readonly) CGFloat minimumLineLength;
@property (nonatomic, assign) CGFloat angleThreshold;
@property (nonatomic, assign) CGFloat minimumAllowedAngle;
@property (nonatomic, assign) CGFloat maximumPathLength;

-(id) initWithMinimumLineLength: (CGFloat) minimumLength;
-(void) processPoint: (CGPoint) newPoint;
-(void) clear;
-(NSInteger) count;
-(IILine2D *) firstLine;
-(IILine2D *) lastLine;
-(void) removeFirstLine;

@end
