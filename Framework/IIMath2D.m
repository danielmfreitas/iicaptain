//
//  Math2D.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye. All rights reserved.
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

@end
