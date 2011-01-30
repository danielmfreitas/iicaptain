//
//  IIMainScene.m
//  iiCaptain
//
//  Created by Richardson Oliveira on 10-07-25.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"
#import "IIGestureManager.h"


@implementation MainScene




+(id) scene 
{
	
	CCScene *mainScene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *menuLayer = [MainScene node];
	
	// add layer as a child to scene
	[mainScene addChild: menuLayer];
	
	// return the scene
	return mainScene;
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		[CCMenuItemFont setFontSize:20];
		[CCMenuItemFont setFontName:@"Helvetica"];
		CCMenuItem *start = [CCMenuItemFont itemFromString:@"Start Game" target:self selector:@selector(newGame:)];
		CCMenuItem *options = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(options:)];
        CCMenuItem *help = [CCMenuItemFont itemFromString:@"Help" target:self selector:@selector(help:)];
		CCMenuItem *credits = [CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(credits:)];
		
		CCMenu *menu = [CCMenu menuWithItems:start, options, help, credits, nil];
		[menu alignItemsVertically];
        [self addChild:menu];	}
	return self;
}

-(void)newGame: (id)sender {
	
	// Creates gesture manager
	IIGestureManager *manager = [IIGestureManager gestureManagerWithTargetView:[CCDirector sharedDirector].openGLView];
    [manager autorelease];
    
    // Creates a single touch and drag recognizer
    UIPanGestureRecognizer *dragRecognizer = [[UIPanGestureRecognizer alloc] init];
    [dragRecognizer setMinimumNumberOfTouches:1];
    [dragRecognizer setMaximumNumberOfTouches:1];
    [dragRecognizer autorelease];
    
    // Creates a single tap recognizer.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    tapRecognizer.numberOfTapsRequired = 1;
    [tapRecognizer autorelease];
    
    // Add the gesture recognizer to the manager
    [manager addGesture: dragRecognizer withTag: @"singleDragGesture"];
    [manager addGesture: tapRecognizer withTag: @"singleTapGesture"];
	
   
	
    GameScene *scene = [[[GameScene alloc] initWithGestureManager: manager] autorelease];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)options: (id)sender{
	
	NSLog(@"Options");

}
-(void)help: (id)sender{
	NSLog(@"Help");

	
}
-(void)credits: (id)sender{
	NSLog(@"Credits");

	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
