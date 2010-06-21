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

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	GLESDebugDraw *m_debugDraw;
    IISmoothPath *path;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
