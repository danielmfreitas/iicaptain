//
//  Math2D.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIMath2D.h"


@implementation IIMath2D

+ (CGFloat) lineLengthFromPoint: (CGPoint) startPoint toEndPoint: (CGPoint) endPoint {
    
    // Uses pitagoras to find the distance: sqrt((x2 - x1)^2 + (y2 - y1)^2).
    CGFloat xDistance = endPoint.x - startPoint.x;
    CGFloat xFactor = xDistance * xDistance;
    
    CGFloat yDistance = endPoint.y - startPoint.y;
    CGFloat yFactor = yDistance * yDistance;
    
    CGFloat distance = sqrtf(xFactor + yFactor);
    return distance;
}

+ (CGFloat) radiansToDegrees: (CGFloat) angleInRadians {
    return angleInRadians * 180 / M_PI;
}

+ (BOOL) lineIsVertical: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd {
    
    if (lineStart.x == lineEnd.x) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) lineIsHorizontal: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd {
    
    if (lineStart.y == lineEnd.y) {
        return YES;
    } else {
        return NO;
    }
}

+ (CGFloat) slopeOfLine: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd {    
    return (lineEnd.y - lineStart.y) / (lineEnd.x - lineStart.x);
}

+ (CGFloat) lineAngleFromX: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd {
    if ([IIMath2D lineIsVertical:lineStart lineEnd:lineEnd]) {
        return M_PI / 2;
    }
    
    if ([IIMath2D lineIsHorizontal: lineStart lineEnd:lineEnd]) {
        return 0;
    }
    
    CGFloat lineSlope = [IIMath2D slopeOfLine: lineStart lineEnd: lineEnd];
    return atanf(lineSlope);
}

+ (CGFloat) angleBetweenLines: (CGPoint) line1Start line1End: (CGPoint) line1End line2Start: (CGPoint) line2Start line2End: (CGPoint) line2End {
    
    CGFloat line1AngleFromX = [IIMath2D lineAngleFromX: line1Start lineEnd: line1End];
    CGFloat line2AngleFromX = [IIMath2D lineAngleFromX: line2Start lineEnd: line2End];
    
    return abs(line1AngleFromX - line2AngleFromX);
}

@end
