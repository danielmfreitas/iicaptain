//
//  Line2D.h
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-14.
//  Copyright Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * A 2D line which uses a texture to render itself on the screen. The texture mapping is set to repeat along its length.
 * <p/>
 * As a subclass of CCSprite, this class inherits all benefits from sprites.
 */
@interface IILine2D : CCSprite {
    CGPoint origin;
    CGPoint end;
    CGPoint midPoint;
    CGFloat length;
}

/**
 * The origin point of the line (i.e. (x1, y1)). Changing the origin point will update the line's length and midPoint
 * accordingly.
 */
@property (nonatomic) CGPoint origin;

/**
 * The end point of the line (i.e. (x1, y1)). Changing the end point will update the line's length and midPoint
 * accordingly.
 */
@property (nonatomic) CGPoint end;

/**
 * The position of the point which split the lines in two equal parts. i.e. the coordinates of the middle of the line.
 */
@property (nonatomic, readonly) CGPoint midPoint;

/**
 * The length of the line.
 */
@property (nonatomic, readonly) CGFloat length;

+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTextureFile: (NSString*) fileName;
+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTexture: (CCTexture2D*) texture;

@end

float calculateLengthFor(CGPoint origin, CGPoint destination);