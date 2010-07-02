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

+ (CGPoint) pointAtLength: (CGFloat) length startPoint: (CGPoint) startPoint endPoint: (CGPoint) endPoint {
    
    CGFloat lineLength = [self lineLengthFromPoint:startPoint toEndPoint:endPoint];
    CGFloat ratio = length / lineLength;
    
    CGFloat xLength = endPoint.x - startPoint.x;
    CGFloat yLength = endPoint.y - startPoint.y;
    
    CGPoint pointAtLength = CGPointMake(startPoint.x + (xLength * ratio), startPoint.y + (yLength * ratio));
    
    return pointAtLength;
}

+ (CGFloat) radiansToDegrees: (CGFloat) angleInRadians {
    return (angleInRadians * 180) / M_PI;
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
    if ([self lineIsVertical: lineStart lineEnd: lineEnd]) {
        return INFINITY;
    } else {
        return (lineEnd.y - lineStart.y) / (lineEnd.x - lineStart.x);
    }
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
    
    CGFloat angleX1 = [self lineAngleFromX: line1Start lineEnd: line1End];
    CGFloat angleX2 = [self lineAngleFromX: line2Start lineEnd: line2End];
    
    if (angleX1 > 0) {
        if (line1End.x < line1Start.x) {
            angleX1 = -M_PI + angleX1;
        }
    } else {
        if (line1End.x < line1Start.x) {
            angleX1 = M_PI + angleX1;
        }
    }
    
    if (angleX2 > 0) {
        if (line2End.x < line2Start.x) {
            angleX2 = -M_PI + angleX2;
        }
    } else {
        if (line2End.x < line2Start.x) {
            angleX2 = M_PI + angleX2;
        }
    }
    
    CGFloat angleBetweenLines = M_PI - fabs(angleX2 - angleX1);
    
    return fabs(angleBetweenLines);
}

@end
