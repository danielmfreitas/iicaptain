//
//  Line2D.m
//  FollowRouteDemo
//
//  Created by Daniel Freitas on 10-06-14.
//  Copyright Eye Eye. All rights reserved.
//

#import "IILine2D.h"
#import "IIMath2D.h"

@implementation IILine2D

@synthesize origin;
@synthesize end;
@synthesize midPoint;
@synthesize length;
@synthesize xTextureTranslate;
@synthesize yTextureTranslate;

/*
 * This method has been copied verbatin from the CCSprite class. This method is not declared in CCSprite interface so it
 * was causing compilation warnings from XCode. This method is required to update the position of the texture within the
 * sprite.
 * Note: This method should be checked when switching to a new version of cocos2d as it might change implementation.
 */
-(void)updateTextureCoords:(CGRect)rect
{
	
	float atlasWidth = texture_.pixelsWide;
	float atlasHeight = texture_.pixelsHigh;
    
	float left = rect.origin.x / atlasWidth;
	float right = (rect.origin.x + rect.size.width) / atlasWidth;
	float top = rect.origin.y / atlasHeight;
	float bottom = (rect.origin.y + rect.size.height) / atlasHeight;
    
	
	if( flipX_)
		CC_SWAP(left,right);
	if( flipY_)
		CC_SWAP(top,bottom);
	
	quad_.bl.texCoords.u = left;
	quad_.bl.texCoords.v = bottom;
	quad_.br.texCoords.u = right;
	quad_.br.texCoords.v = bottom;
	quad_.tl.texCoords.u = left;
	quad_.tl.texCoords.v = top;
	quad_.tr.texCoords.u = right;
	quad_.tr.texCoords.v = top;
}

/*
 * Calculates the required rotation so the sprite sits on top of the line.
 */
- (CGFloat) calculateRotationWithXLength: (CGFloat) xLength startPoint: (CGPoint) startPoint endPoint: (CGPoint) endPoint yLength: (CGFloat) yLength  {
  
    CGFloat rotation;
  
    if (startPoint.x == endPoint.x) { // Line is vertical
        
        if (yLength > 0) {
            rotation = 0;
        } else {
            rotation = -180;
        }
        
    } else if (startPoint.y == endPoint.y) { // Line is horizontal
        
        if (xLength > 0) {
            rotation = 90;
        } else {
            rotation = -90;
        }
        
    } else {
        
        CGFloat slope = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
        
        if (xLength >= 0) {
            rotation = 90 - [IIMath2D radiansToDegrees:atanf(slope)];
        } else {
            rotation = -90 - [IIMath2D radiansToDegrees:atanf(slope)];
        }
    }
  
    return rotation;
}

/*
 * Calculates the line information: length, midpoint, rotation etc...
 */
- (void) setupWithStartPoint: (CGPoint) startPoint andEndPoint: (CGPoint) endPoint {
    origin = startPoint;
    end = endPoint;
    length = [IIMath2D lineLengthFromPoint:startPoint toEndPoint:endPoint];
    
    /*
     * The yOffset is how many pixels we have to shift down the texture along the Y axis so we have the bottom of the
     * image aligned with the start of the line. Since in iphone the screen coordinates are inverted in relation to
     * OpenGLES and cocos, the texture is repeated from top to bottom, instead of bottom to top.
     */
    yOffset = (int) length % (int) self.textureRect.size.height;
    
    CGFloat xLength = endPoint.x - startPoint.x;
    CGFloat yLength = endPoint.y - startPoint.y;
    midPoint = CGPointMake(startPoint.x + (xLength / 2), startPoint.y + (yLength / 2));

    CGFloat rotation = [self calculateRotationWithXLength: xLength startPoint: startPoint endPoint: endPoint yLength: yLength];

    // Set open GL to repeat the texture along width and height.
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [self.texture setTexParameters:&params];
    
    // Increase the texture rect to the length of the line so the texture repeats thought the full length of the line.
    [self setTextureRect: CGRectMake(0.0, 0.0, self.textureRect.size.width, self.length)];
    
    // Move the sprite to the mid point of the line and rotate it so it forms the line.
    [self setPosition:midPoint];
    [self setRotation: rotation];
    
    /*
     * Sets the default texture translate. This is required so that the texture position is initialized with the
     * calculated yOffset.
     */
    self.xTextureTranslate = 0;
    self.yTextureTranslate = 0;
}

- (id) initFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTextureFile: (NSString*) fileName {
    if ((self = [self initWithFile:fileName])) {
        [self setupWithStartPoint:startPoint andEndPoint:endPoint];
    }
    
    return self;
}

- (id) initFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTexture: (CCTexture2D*) texture {
    if ((self = [self initWithTexture:texture])) {
        [self setupWithStartPoint:startPoint andEndPoint:endPoint];
    }
    
    return self;
}

- (void) setOrigin:(CGPoint) point {
    [self setupWithStartPoint:point andEndPoint:end];
}

- (void) setEnd:(CGPoint) point {
    [self setupWithStartPoint:origin andEndPoint:point];
}

- (void) setXTextureTranslate: (float) offset {
    xTextureTranslate = offset;
    [self updateTextureCoords:CGRectMake(-xTextureTranslate, yTextureTranslate - yOffset,
                                         self.textureRect.size.width, self.length)];
}

- (void) setYTextureTranslate: (float) offset {
    yTextureTranslate = offset;
    [self updateTextureCoords:CGRectMake(-xTextureTranslate, yTextureTranslate - yOffset,
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