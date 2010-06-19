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

- (void) setupWithStartPoint: (CGPoint) startPoint andEndPoint: (CGPoint) endPoint {
    origin = startPoint;
    end = endPoint;
    length = [IIMath2D lineLengthFromPoint:startPoint toEndPoint:endPoint];
    
    CGFloat xLength = endPoint.x - startPoint.x;
    CGFloat yLength = endPoint.y - startPoint.y;
    midPoint = CGPointMake(startPoint.x + (xLength / 2), startPoint.y + (yLength / 2));

    CGFloat rotation = 0;
    
    if (startPoint.x == endPoint.x) { // Line is vertical
        rotation = 0;
    } else if (startPoint.y == endPoint.y) { // Line is horizontal
        rotation = 90;
    } else {
        CGFloat slope = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
        
        if (xLength >= 0) {
            rotation = 90 - [IIMath2D radiansToDegrees:atanf(slope)];
        } else {
            rotation = -90 - [IIMath2D radiansToDegrees:atanf(slope)];
        }
    }

    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    CGRect originalTextureRect = self.textureRect;
    
    [self.texture setTexParameters:&params];
    [self setTextureRect: CGRectMake(0.0, 0.0, originalTextureRect.size.width, self.length)];
    [self setPosition:midPoint];
    [self setRotation: rotation];
    [self setFlipY: YES];
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

+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTextureFile: (NSString*) fileName {
    IILine2D *result = [[IILine2D alloc] initFromOrigin: startPoint toEnd: endPoint withTextureFile: fileName];
    
    return [result autorelease];
}

+ (IILine2D *) lineFromOrigin: (CGPoint) startPoint toEnd: (CGPoint) endPoint withTexture: (CCTexture2D*) texture{
    IILine2D *result = [[IILine2D alloc] initFromOrigin: startPoint toEnd: endPoint withTexture: texture];
    
    return [result autorelease];
}

@end