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
 * This class also adds some utilities to manipulate the position of the texture on the sprite.
 * <p/>
 * As a subclass of CCSprite, this class inherits all benefits from sprites.
 */
@interface IILine2D : CCSprite {
    CGPoint origin;
    CGPoint end;
    CGPoint midPoint;
    CGFloat length;
    CGFloat yOffset;
    CGFloat xTextureTranslate;
    CGFloat yTextureTranslate;
}

/**
 * The origin point of the line (i.e. (x1, y1)). Changing the origin point will update the line's length and midPoint
 * accordingly.
 */
@property (nonatomic) CGPoint origin;

/**
 * The end point of the line (i.e. (x2, y2)). Changing the end point will update the line's length and midPoint
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

/**
 * Translates the texture withing the sprite alongside the Y axis by the specified offset. The offset will translate the
 * texture up the Y axis (i.e. the texture will appear to have moved up). Usefull for animation.
 */
@property (nonatomic) CGFloat xTextureTranslate;

/**
 * Translates the texture withing the sprite alongside the X axis by the specified offset. The offset will translate the
 * texture rigth the X axis (i.e. the texture will appear to have moved to the right). Usefull for animation.
 */
@property (nonatomic) CGFloat yTextureTranslate;

/**
 * Creates a line with start point and end point coordinates with a texture loaded from the specified file image.
 */
+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTextureFile: (NSString*) fileName;

/**
 * Creates a line with start point and end point coordinates with the given texture.
 */
+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTexture: (CCTexture2D*) texture;

@end