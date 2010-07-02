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

// 1.5707 rad =~ 90 degrees
#define MIN_ANGLE_BEFORE_SMOOTH_IN_RADS 2.8

@implementation IISmoothPath

@synthesize minimumLineLength;

- (id) initWithMinimumLineLength: (CGFloat) minimumLength {
    
    if ((self = [super init])) {
        linesInPath = [[NSMutableArray alloc] init];
        minimumLineLength = minimumLength;
        firstPoint = CGPointZero;
    }

    return self;
}

- (void) smoothPath {
    
    // Bail out if there are not at least two lines.
    if ([linesInPath count] < 2) {
        return;
    }
    
    IILine2D *previousLine = [linesInPath objectAtIndex: [linesInPath count] - 2];
    IILine2D *lastLine = [linesInPath lastObject];
    
    CGFloat angleBetweenLastTwoLines = [IIMath2D angleBetweenLines:previousLine.startPoint
                                                          line1End:previousLine.endPoint
                                                        line2Start:lastLine.startPoint
                                                          line2End:lastLine.endPoint];
    
    if (angleBetweenLastTwoLines <= MIN_ANGLE_BEFORE_SMOOTH_IN_RADS) {

        //1 - In the previous line, get the point at length - minimumLineLength.
        CGPoint newPointPreviousLine = [IIMath2D pointAtLength: (previousLine.length - minimumLineLength)
                                                    startPoint: previousLine.startPoint
                                                      endPoint: previousLine.endPoint];
            
        //2 - In the last line. Get the point at minimumLineLength.
        CGPoint newPointLastLine = [IIMath2D pointAtLength: minimumLineLength startPoint: lastLine.startPoint
                                          endPoint: lastLine.endPoint];
        
        //3 - Adjust points so dintance between them is multiple of minimumLineLength.
        CGFloat newLineLength = [IIMath2D lineLengthFromPoint: newPointPreviousLine toEndPoint: newPointLastLine];
        
        NSInteger lengthMultiple = (NSInteger) (newLineLength / minimumLineLength);
        
        if (lengthMultiple == 0) {
            lengthMultiple = 1;
        }
        
        CGFloat adjustedLength = lengthMultiple * minimumLineLength; 
        CGFloat lineRatio = adjustedLength / newLineLength;
        
        CGFloat adjustedX = newPointPreviousLine.x + ((newPointLastLine.x - newPointPreviousLine.x) * lineRatio);
        CGFloat adjustedY = newPointPreviousLine.y + ((newPointLastLine.y - newPointPreviousLine.y) * lineRatio);
        
        newPointLastLine = CGPointMake(adjustedX, adjustedY);
        
        //4 - Move last line start point to new last line point, respecting minimumLineLength.
        lastLine.startPoint = newPointLastLine;
        CGFloat distanceBetweenOriginalLines = [IIMath2D lineLengthFromPoint:newPointPreviousLine toEndPoint:lastLine.endPoint];
        
        BOOL removeLastLine = NO;
        
        if (distanceBetweenOriginalLines <= minimumLineLength) {
            removeLastLine = YES;
        } else {
            lastLine.startPoint = newPointLastLine;
            lengthMultiple = (NSInteger) (lastLine.length / minimumLineLength);
            
            if (lengthMultiple == 0) {
                lengthMultiple = 1;
            }
            
            adjustedLength = lengthMultiple * minimumLineLength; 
            lineRatio = adjustedLength / lastLine.length;
            
            adjustedX = lastLine.startPoint.x + ((lastLine.endPoint.x - lastLine.startPoint.x) * lineRatio);
            adjustedY = lastLine.startPoint.y + ((lastLine.endPoint.y - lastLine.startPoint.y) * lineRatio);
            
            lastLine.endPoint = CGPointMake(adjustedX, adjustedY);
        }

        //5 - Move previous line end point to new previous line point.
        previousLine.endPoint = newPointPreviousLine;
        
        //6 - Now connect a new line between the points.
        IILine2D *newLine = [IILine2D lineFromOrigin:newPointPreviousLine toEnd:newPointLastLine withTextureFile:@"path_texture.png"];
        [linesInPath removeLastObject];
        [linesInPath addObject:newLine];
        [self addChild:newLine];
        
        if (!removeLastLine) {
            [linesInPath addObject:lastLine];
            lastPoint = lastLine.endPoint;
        } else {
            [self removeChild:lastLine cleanup:YES];
            lastPoint = newLine.endPoint;
        }
    }
}

- (void) processPoint: (CGPoint)newPoint {
    
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
            [linesInPath addObject:line];
            [self addChild:line];
            lastPoint = adjustedPoint;
            
            [self smoothPath];
        }
    }
}

- (void) clear {

    for (IILine2D *line in linesInPath) {
        [self removeChild:line cleanup:YES];
    }
    
    [linesInPath removeAllObjects];
    firstPoint = CGPointZero;
}

- (NSInteger) count {
    return [linesInPath count];
}

- (IILine2D *) firstLine {
    if (linesInPath.count == 0) {
        return nil;
    } else {
        return [linesInPath objectAtIndex:0];
    }
}

- (IILine2D *) lastLine {
    if (linesInPath.count == 0) {
        return nil;
    } else {
        return [linesInPath lastObject];
    }

}

- (void) removeFirstLine {
    if (linesInPath.count > 0) {
        IILine2D *firstLine = [self firstLine];
        [linesInPath removeObjectAtIndex:0];
        [self removeChild:firstLine cleanup:YES];
    }
}

- (void) dealloc {
    [linesInPath release];
    
    [super dealloc];
}

@end
