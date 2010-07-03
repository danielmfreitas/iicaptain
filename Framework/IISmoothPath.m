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

// 2.7925 rad =~ 160 degrees
#define MIN_ANGLE_BEFORE_SMOOTH_IN_RADS 2.7925

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

/**
 * Given the line formed by the two points, calculates a new end point to guarante line length is multiple of
 * minimum line length. The new point will guarante the line has length at least equal to minimum length.
 */
- (CGPoint) calculateLengthToBeMultipleOfMinimumLength: (CGPoint) startPoint endPoint: (CGPoint) endPoint {
    CGFloat lineLength = [IIMath2D lineLengthFromPoint: startPoint toEndPoint: endPoint];
    
    NSInteger lengthMultiple = (NSInteger) (lineLength / minimumLineLength);
    
    if (lengthMultiple == 0) {
        lengthMultiple = 1;
    }
    
    CGFloat adjustedLength = lengthMultiple * minimumLineLength; 
    CGFloat lineRatio = adjustedLength / lineLength;
    
    CGFloat adjustedX = startPoint.x + ((endPoint.x - startPoint.x) * lineRatio);
    CGFloat adjustedY = startPoint.y + ((endPoint.y - startPoint.y) * lineRatio);
    
    return CGPointMake(adjustedX, adjustedY);
}

- (void) smoothPath {
    
    // Bail out if there are not at least two lines.
    if ([linesInPath count] < 2) {
        return;
    }
    
    // Get last two lines
    IILine2D *previousLine = [linesInPath objectAtIndex: [linesInPath count] - 2];
    IILine2D *lastLine = [linesInPath lastObject];
    
    // If last line is a point, skip.
    if (previousLine.startPoint.x == previousLine.endPoint.x && previousLine.startPoint.y == previousLine.endPoint.y) {
        NSLog(@"Last line is a point. Return.");
        return;
    }
    
    // Get the angle between the two lines and see if it is too sharp. Igf it is, smooth it out.
    CGFloat angleBetweenLastTwoLines = [IIMath2D angleBetweenLines:previousLine.startPoint
                                                          line1End:previousLine.endPoint
                                                        line2Start:lastLine.startPoint
                                                          line2End:lastLine.endPoint];
    
    if (angleBetweenLastTwoLines <= MIN_ANGLE_BEFORE_SMOOTH_IN_RADS) {

        //1 - In the previous line, get the point at (length - minimumLineLength).
        CGPoint newPointPreviousLine = [IIMath2D pointAtLength: (previousLine.length - minimumLineLength)
                                                    startPoint: previousLine.startPoint
                                                      endPoint: previousLine.endPoint];
            
        //2 - In the last line. Get the point at minimumLineLength.
        CGPoint newPointLastLine = [IIMath2D pointAtLength: minimumLineLength startPoint: lastLine.startPoint
                                          endPoint: lastLine.endPoint];
        
        //3 - Adjust new points so that the distance between them is a multiple of minimumLineLength.
        newPointLastLine = [self calculateLengthToBeMultipleOfMinimumLength:newPointPreviousLine endPoint:newPointLastLine];
        
        //4 - Move last line start point to new created point.
        //    Check new length of last line and adjust it to a multiple of minimumLineLength.
        lastLine.startPoint = newPointLastLine;
        CGFloat distanceBetweenOriginalLines = [IIMath2D lineLengthFromPoint:newPointPreviousLine toEndPoint:lastLine.endPoint];
        
        if (distanceBetweenOriginalLines <= minimumLineLength) {
            // If the distance between the first new point and last line's end point <= minimum length we need to remove
            // the last line. TODO removing last line still does not look so good.
            lastLine.endPoint = lastLine.startPoint;
        } else {
            // If the distance > minimum length, then move lastLine's star point to the new point and adjust ist's length
            // to respect minimumLineLength ratio.
            lastLine.startPoint = newPointLastLine;
            lastLine.endPoint = [self calculateLengthToBeMultipleOfMinimumLength:lastLine.startPoint endPoint:lastLine.endPoint];
        }

        //5 - Move previous line end point to the first new point.
        previousLine.endPoint = newPointPreviousLine;
        
        //6 - Now connect a new line between the new points.
        IILine2D *newLine = [IILine2D lineFromOrigin:newPointPreviousLine toEnd:newPointLastLine withTextureFile:@"path_texture.png"];
        [linesInPath removeLastObject];
        [linesInPath addObject:newLine];
        [self addChild:newLine];
        
        //Do a final check to see if the last line should be removed or not.
        [linesInPath addObject:lastLine];
        lastPoint = lastLine.endPoint;
    }
}

- (void) processPoint: (CGPoint)newPoint {
    
    if (CGPointEqualToPoint(firstPoint, CGPointZero)) {
        firstPoint = newPoint;
        lastPoint = firstPoint;
    } else {
        if ([IIMath2D lineLengthFromPoint:lastPoint toEndPoint:newPoint] >= minimumLineLength) {
            
            CGPoint adjustedPoint = [self calculateLengthToBeMultipleOfMinimumLength:lastPoint endPoint:newPoint];
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
