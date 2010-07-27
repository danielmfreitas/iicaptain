//
//  HelloWorldScene.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye 2010. All rights reserved.
//

#import "IIGameScene.h"
#import "cocos2d.h"

@class IICaptain;
@class CCSpriteSheet;

@interface GameScene : IIGameScene {
    CCSpriteSheet *heroSpriteSheet;
    IICaptain *hero;
	CCTMXTiledMap *sea;
}

@property (readonly) IICaptain *hero;

@end
