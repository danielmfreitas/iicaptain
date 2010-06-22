//
//  SmoothPath.h
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-12.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "IILine2D.h"


@interface IISmoothPath : CCNode {
    NSMutableArray* linesInPath;
    CGPoint firstPoint;
    CGPoint lastPoint;
    CGFloat minimumLineLength;
    BOOL acceptingInput;
    NSInteger iterationIndex; // TODO temporary solution to test movement animation.
}

@property (nonatomic, readonly) CGFloat minimumLineLength;
@property (nonatomic, readonly) BOOL acceptingInput;
@property (nonatomic, readonly) NSInteger iterationIndex;

-(id) initWithMinimumLineLength: (CGFloat) minimumLength;
-(void) processPoint: (CGPoint) newPoint;
-(void) clear;
-(void) startAcceptingInput;
-(void) stopAcceptingInput;
-(NSInteger) count;
-(IILine2D *) firstLine;
-(IILine2D *) nextLine;
-(IILine2D *) lastLine;

@end
