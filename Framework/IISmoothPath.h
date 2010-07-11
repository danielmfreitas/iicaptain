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
}

@property (nonatomic, readonly) CGFloat minimumLineLength;

-(id) initWithMinimumLineLength: (CGFloat) minimumLength;
-(void) processPoint: (CGPoint) newPoint;
-(void) clear;
-(NSInteger) count;
-(IILine2D *) firstLine;
-(IILine2D *) lastLine;
-(void) removeFirstLine;

@end
