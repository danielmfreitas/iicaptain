//
//  Math2D.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye. All rights reserved.
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
 * Converts radians to degrees.
 */
+ (CGFloat) radiansToDegrees: (CGFloat) angleInRadians;

@end
