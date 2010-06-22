//
//  Line2D.m
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-14.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IILine2D.h"
#import "IIMath2D.h"

@implementation IILine2D

@synthesize startPoint;
@synthesize endPoint;
@synthesize midPoint;
@synthesize length;
@synthesize xTextureTranslate;
@synthesize yTextureTranslate;

/*
 * Calculates the required rotation so the sprite sits on top of the line.
 */
- (CGFloat) calculateRotationWithXLength: (CGFloat) xLength yLength: (CGFloat) yLength startPoint: (CGPoint) p1 endPoint: (CGPoint) p2 {
  
    CGFloat rotation;
  
    if (p1.x == p2.x) { // Line is vertical
        
        if (yLength > 0) {
            rotation = 0;
        } else {
            rotation = -180;
        }
        
    } else if (p1.y == p2.y) { // Line is horizontal
        
        if (xLength > 0) {
            rotation = 90;
        } else {
            rotation = -90;
        }
        
    } else {
        
        CGFloat slope = (p2.y - p1.y) / (p2.x - p1.x);
        
        if (xLength >= 0) {
            rotation = 90 - [IIMath2D radiansToDegrees:atanf(slope)];
        } else {
            rotation = -90 - [IIMath2D radiansToDegrees:atanf(slope)];
        }
    }
  
    return rotation;
}

/*
 * Calculates the line attributes: length, midpoint, rotation etc...
 */
- (void) setupFromPoint: (CGPoint) aPoint toPoint: (CGPoint) finalPoint {
    startPoint = aPoint;
    endPoint = finalPoint;
    length = [IIMath2D lineLengthFromPoint:aPoint toEndPoint:finalPoint];
    
    CGFloat xLength = finalPoint.x - aPoint.x;
    CGFloat yLength = finalPoint.y - aPoint.y;
    midPoint = CGPointMake(aPoint.x + (xLength / 2), aPoint.y + (yLength / 2));

    CGFloat rotation = [self calculateRotationWithXLength: xLength yLength: yLength startPoint: aPoint endPoint: finalPoint];

    // Set open GL to repeat the texture along width and height.
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [self.texture setTexParameters:&params];
    
    // Increase the texture rect to the length of the line so the texture repeats thought the full length of the line.
    [self setTextureRect: CGRectMake(0.0, 0.0, self.textureRect.size.width, self.length)];
    
    // Move the sprite to the mid point of the line and rotate it so it forms the line.
    [self setPosition: midPoint];
    [self setRotation: rotation];
    
    /*
     * Sets the default texture translate. This is required so that the texture position is initialized with the
     * calculated yOffset through the updateTextureCoords function.
     */
    self.xTextureTranslate = 0;
    self.yTextureTranslate = 0;
}

- (id) initFromOrigin: (CGPoint) p1 toEnd: (CGPoint) p2 withTextureFile: (NSString*) fileName {
    if ((self = [self initWithFile:fileName])) {
        [self setupFromPoint:p1 toPoint:p2];
    }
    
    return self;
}

- (id) initFromOrigin: (CGPoint) p1 toEnd: (CGPoint) p2 withTexture: (CCTexture2D*) texture {
    if ((self = [self initWithTexture:texture])) {
        [self setupFromPoint:p1 toPoint:p2];
    }
    
    return self;
}

- (void) setStartPoint:(CGPoint) point {
    [self setupFromPoint:point toPoint:endPoint];
}

- (void) setEndPoint:(CGPoint) point {
    [self setupFromPoint:startPoint toPoint:point];
}

- (void) setXTextureTranslate: (float) offset {
    xTextureTranslate = offset;
    [self setTextureRect:CGRectMake(-xTextureTranslate, yTextureTranslate - yOffset,
                                    self.textureRect.size.width, self.length)];
}

- (void) setYTextureTranslate: (float) offset {
    yTextureTranslate = offset;
    [self setTextureRect:CGRectMake(-xTextureTranslate, yTextureTranslate - yOffset,
                                    self.textureRect.size.width, self.length)];
}


+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTextureFile: (NSString*) fileName {
    IILine2D *result = [[IILine2D alloc] initFromOrigin: startPoint toEnd: endPoint withTextureFile: fileName];
    
    return [result autorelease];
}

+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTexture: (CCTexture2D*) texture{
    IILine2D *result = [[IILine2D alloc] initFromOrigin: startPoint toEnd: endPoint withTexture: texture];
    
    return [result autorelease];
}

@end