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
#import "IIGameScene.h"
#import "MainScene.h"
#import "IICaptain.h"

#define SIXTY_DEGREES_IN_RADS 1.04719755

@implementation IISmoothPath

@synthesize minimumLineLength;
@synthesize angleThreshold;
@synthesize minimumAllowedAngle;
@synthesize maximumPathLength;

- (id) initWithMinimumLineLength: (CGFloat) minimumLength {
    
    if ((self = [super init])) {
        linesInPath = [[NSMutableArray alloc] init];
        minimumLineLength = minimumLength;
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

/**
 * Add the line to the path and node.
 */
- (void) addLine: (IILine2D *) line {
    [linesInPath addObject:line];
    [self addChild:line];
}

/**
 * Remove the line from the path and node.
 */
- (void) removeLine: (IILine2D *) line {
    [linesInPath removeObject:line];
    [self removeChild:line cleanup:YES];
}

- (void) smoothPath {
    
    // Bail out if there are not at least two lines.
    if ([linesInPath count] < 2) {
        return;
    }
    
    // Get last two lines
    IILine2D *previousLine = [linesInPath objectAtIndex: [linesInPath count] - 2];
    IILine2D *lastLine = [linesInPath lastObject];
    
    // If length of previous line < minimumLength, than ship is moving through it and is almost done. Ignore smooth then
    // or else previousLine end point will be moved BEFORE the start point, reverting the line direction.
    // For float point comparison, assume a tolerance of 0.001
    if ((previousLine.length - minimumLineLength) < -0.001) {
        return;
    }
    
    // If last line is a POISON point, skip and remove. This will prevent the algorithm from removing last smoothed line.
    if (previousLine.startPoint.x == previousLine.endPoint.x && previousLine.startPoint.y == previousLine.endPoint.y) {
        [self removeLine:previousLine];
        return;
    }
    
    // Get the angle between the two lines and see if it is too small. If it is, smooth it out.
    CGFloat angleBetweenLastTwoLines = [IIMath2D angleBetweenLines:previousLine.startPoint
                                                          line1End:previousLine.endPoint
                                                        line2Start:lastLine.startPoint
                                                          line2End:lastLine.endPoint];
    
    if (angleBetweenLastTwoLines <= angleThreshold) {

        //1 - In the previous line, get the new point at (length - minimumLineLength).
        CGPoint newPointPreviousLine = [IIMath2D pointAtLength: (previousLine.length - minimumLineLength)
                                                    startPoint: previousLine.startPoint
                                                      endPoint: previousLine.endPoint];
            
        //2 - In the last line. Get the new point at minimumLineLength.
        CGPoint newPointLastLine = [IIMath2D pointAtLength: minimumLineLength startPoint: lastLine.startPoint
                                          endPoint: lastLine.endPoint];
        
        //3 - Adjust end new point so that the new line length is a multiple of minimumLineLength.
        newPointLastLine = [self calculateLengthToBeMultipleOfMinimumLength:newPointPreviousLine
                                                                   endPoint:newPointLastLine];
        
        //4 - Move last line start point to new created point.
        //    Check new length of last line and adjust it to a multiple of minimumLineLength.
        lastLine.startPoint = newPointLastLine;
        
        if (angleBetweenLastTwoLines <= SIXTY_DEGREES_IN_RADS) {
            // If the angle <= 60 degrees (equilateral triangle), setting the start point to the new point will put it
            // AFTER the end point, inverting the direction of the line. If this happens, it means that the angle is so
            // sharp that subsequent calls to smooth the path will remove the last smoothed line, giving a result less
            // than ideal. If this happens, we just "remove" the last line by turning it to a POISON point. This will
            // avoid the algorithm to try to smooth the new added line again, which would remove the smooth appearance.
            lastLine.endPoint = lastLine.startPoint;
        } else {
            // If the angle > 60 degrees, then move lastLine's star point to the new point and adjust ist's length
            // to respect minimumLineLength ratio.
            lastLine.endPoint = [self calculateLengthToBeMultipleOfMinimumLength:lastLine.startPoint
                                                                        endPoint:lastLine.endPoint];
        }

        //5 - Move previous line end point to the first new point.
        previousLine.endPoint = newPointPreviousLine;
        
        //6 - Now connect a new line between the new points.
        IILine2D *newLine = [IILine2D lineFromOrigin:newPointPreviousLine toEnd:newPointLastLine withTextureFile:@"path_texture.png"];
        
        // Remove last line to reinsert it after new line.
        [linesInPath removeObject:lastLine];
        
        // If previous line new length is zero, remove it.
        if (previousLine.length == 0) {
            [self removeLine:previousLine];
        }
        
        [self addLine:newLine];
        [linesInPath addObject:lastLine];
    }
}

// TODO Is there a faster way to do this? Maybe lazily calculate value and store result as lines are added/removed?
- (CGFloat) pathLength {
    CGFloat totalLength = 0;
    
    for (IILine2D *line in linesInPath) {
        totalLength += line.length;
    }
    
    return totalLength;
}

- (void) processPoint: (CGPoint) newPoint {
    
    static IILine2D *firstLineInPath = nil;
    
    if ([linesInPath count] == 0) {
        if (firstLineInPath == nil) {
            firstLineInPath = [IILine2D lineFromOrigin:newPoint toEnd:newPoint withTextureFile:@"path_texture.png"];
            [firstLineInPath retain];
            acceptingInput = YES;
        } else {
            if ([IIMath2D lineLengthFromPoint:firstLineInPath.endPoint toEndPoint:newPoint] >= minimumLineLength) {
                CGPoint adjustedPoint = [self calculateLengthToBeMultipleOfMinimumLength: firstLineInPath.endPoint endPoint:newPoint];
                firstLineInPath.endPoint = adjustedPoint;
                
                [self addLine:firstLineInPath];
                [firstLineInPath release];
                firstLineInPath = nil;
            }
        }
    } else {
        if (!acceptingInput) {
            return;
        }
        
        if ([IIMath2D lineLengthFromPoint:[self lastLine].endPoint toEndPoint:newPoint] >= minimumLineLength) {
            
            CGPoint adjustedPoint = [self calculateLengthToBeMultipleOfMinimumLength:[self lastLine].endPoint endPoint:newPoint];
            
            IILine2D *lastLine = [linesInPath lastObject];
            IILine2D *line = [IILine2D lineFromOrigin:[self lastLine].endPoint toEnd:adjustedPoint withTextureFile:@"path_texture.png"];
            
            CGFloat angleBetweenLines = [IIMath2D angleBetweenLines:lastLine.startPoint line1End:lastLine.endPoint line2Start:line.startPoint line2End:line.endPoint];
            
            if (angleBetweenLines > minimumAllowedAngle) {
                [self addLine:line];
                [self smoothPath];
                
                if ([self pathLength] >= maximumPathLength) {
                    acceptingInput = NO;
                }
            } 
        }
    }
}

- (void) clear {

    for (IILine2D *line in linesInPath) {
        [self removeChild:line cleanup:YES];
    }
    
    [linesInPath removeAllObjects];
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
        [self removeLine:firstLine];
    }
}

- (void) dealloc {
    [linesInPath release];
    
    [super dealloc];
}

@end
