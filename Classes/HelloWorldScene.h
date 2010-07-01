//
//  HelloWorldScene.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "IISmoothPath.h"
#import <cocos2d/CCSpriteSheet.h>
#import "IICaptain.h"
#import "IIGestureManager.h"

// HelloWorld Layer
@interface HelloWorld : CCColorLayer
{
	GLESDebugDraw *m_debugDraw;
    CCSpriteSheet *heroSpriteSheet;
    IICaptain *hero;
    IIGestureManager *manager;
}

@property (nonatomic, retain) IIGestureManager *manager;

// returns a Scene that contains the HelloWorld as the only child
+(id) sceneAndManager: (IIGestureManager *) theManager;

-(id) initWithManager: (IIGestureManager *) theManager;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
