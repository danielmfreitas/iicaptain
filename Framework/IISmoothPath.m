//
//  SmoothPath.m
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-12.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IISmoothPath.h"
#import "IILine2D.h"
#import "IIMath2D.h"

// 2.95 rad =~ 169 degrees
#define MAX_ANGLE_IN_RADS 2.95

@implementation IISmoothPath

@synthesize minimumLineLength;
@synthesize acceptingInput;
@synthesize iterationIndex;

-(id) initWithMinimumLineLength: (CGFloat) minimumLength {

    if ((self = [super init])) {
        linesInPath = [[NSMutableArray alloc] init];
        minimumLineLength = minimumLength;
        firstPoint = CGPointZero;
        acceptingInput = NO;
    }

    return self;
}

- (void) processPoint:(CGPoint)newPoint {
    
    if (CGPointEqualToPoint(firstPoint, CGPointZero)) {
        firstPoint = newPoint;
        lastPoint = firstPoint;
    } else {
        if ([IIMath2D lineLengthFromPoint:lastPoint toEndPoint:newPoint] >= minimumLineLength) {
            
            CGFloat length = [IIMath2D lineLengthFromPoint:lastPoint toEndPoint:newPoint];
            NSInteger lengthMultiple = (NSInteger) (length / minimumLineLength);
            CGFloat adjustedLength = lengthMultiple * minimumLineLength; 
            CGFloat lineRatio = adjustedLength / length;
            
            CGFloat adjustedX = lastPoint.x + ((newPoint.x - lastPoint.x) * lineRatio);
            CGFloat adjustedY = lastPoint.y + ((newPoint.y - lastPoint.y) * lineRatio);
            
            CGPoint adjustedPoint = CGPointMake(adjustedX, adjustedY);
            IILine2D *line = [IILine2D lineFromOrigin:lastPoint toEnd:adjustedPoint withTextureFile:@"path_texture.png"];
            IILine2D *lastLine = [self lastLine];
            
            if ([IIMath2D angleBetweenLines:lastLine.startPoint line1End:lastLine.endPoint
                                 line2Start:lastLine.startPoint line2End:lastLine.endPoint] <= MAX_ANGLE_IN_RADS
                                 && lastLine.length <= minimumLineLength * 2) {
                // TODO Add algorithm to smooth lines
                [linesInPath addObject:line];
                [self addChild:line];
            } else {
                [linesInPath addObject:line];
                [self addChild:line];
            }

            lastPoint = adjustedPoint;
        }
    }
}

-(void) clear {

    for (IILine2D *line in linesInPath) {
        [self removeChild:line cleanup:YES];
    }
    
    [linesInPath removeAllObjects];
    firstPoint = CGPointZero;
}

-(NSInteger) count {
    return [linesInPath count];
}

-(IILine2D *) firstLine {
    if (linesInPath.count == 0) {
        return nil;
    } else {
        iterationIndex = 0;
        return [linesInPath objectAtIndex:0];
    }
}

-(IILine2D *) nextLine {
    if (iterationIndex < linesInPath.count - 1) {
        iterationIndex++;
        return [linesInPath objectAtIndex:iterationIndex];
    } else {
        return nil;
    }

}

-(IILine2D *) lastLine {
    if (linesInPath.count == 0) {
        return nil;
    } else {
        return [linesInPath lastObject];
    }

}

-(void) startAcceptingInput {
    acceptingInput = YES;
}

-(void) stopAcceptingInput {
    acceptingInput = NO;
}

- (void) dealloc {
    [linesInPath release];
    
    [super dealloc];
}

@end
