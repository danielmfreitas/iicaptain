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
#import "IILine2D.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	GLESDebugDraw *m_debugDraw;
    IILine2D *line;
    IILine2D *line2;
    IILine2D *line3;
    IILine2D *line4;
    IILine2D *line5;
    IILine2D *line6;
    IILine2D *line7;
    IILine2D *line8;
    IILine2D *line9;
    IILine2D *line10;
    
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
