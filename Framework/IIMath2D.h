//
//  Math2D.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Utility class with convenience methods for 2D geometry.
 */
@interface IIMath2D : NSObject {
    
}

/**
 * Calculates the length of a line given the line's start point and end point.
 * <p/>
 * This method uses pitagoras to do the calculation. That means it will perform two multiplications and one squere root.
 * Keep in mind performance issues.
 */
+ (CGFloat) lineLengthFromPoint: (CGPoint) startPoint toEndPoint: (CGPoint) endPoint;

/**
 * Gets the point in the line formed by the start and end points at the specified length from the star point.
 */
+ (CGPoint) pointAtLength: (CGFloat) length startPoint: (CGPoint) startPoint endPoint: (CGPoint) endPoint;

/**
 * Converts radians to degrees.
 */
+ (CGFloat) radiansToDegrees: (CGFloat) angleInRadians;

/**
 * Calculates the acute angle (in radians) between two lines.
 */
+ (CGFloat) angleBetweenLines: (CGPoint) line1Start line1End: (CGPoint) line1End line2Start: (CGPoint) line2Start line2End: (CGPoint) line2End;

/**
 * Checks if the line formed by two points is vertical.
 */
+ (BOOL) lineIsVertical: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd;

/**
 * Checks if the line formed by two points is horizontal.
 */
+ (BOOL) lineIsHorizontal: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd;

/**
 * Calculate the angle (in rads) that the line forms with the x-axis.
 */
+ (CGFloat) lineAngleFromX: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd;

/**
 * Calculate the slope of a line. Note: a division by 0 will occur if the line is vertical.
 */
+ (CGFloat) slopeOfLine: (CGPoint) lineStart lineEnd: (CGPoint) lineEnd;

@end
