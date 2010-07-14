//
//  HelloWorldScene.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye 2010. All rights reserved.
//

#import "IIGameScene.h"

@class IICaptain;
@class CCSpriteSheet;

@interface HelloWorld : IIGameScene {
    CCSpriteSheet *heroSpriteSheet;
    IICaptain *hero;
}

@property (readonly) IICaptain *hero;

@end
