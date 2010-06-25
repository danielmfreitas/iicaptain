//
//  HelloWorldScene.mm
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye 2010. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"
#import "IILine2D.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagSpriteSheet = 1,
	kTagAnimation1 = 1,
};


// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		[self schedule: @selector(tick:)];
        
        heroSpriteSheet = [CCSpriteSheet spriteSheetWithFile:@"ship.png"];
        [self addChild:heroSpriteSheet z:1];
        
        hero = [IICaptain spriteWithTexture:heroSpriteSheet.texture rect:CGRectMake(0, 0, 32, 32)];
        [heroSpriteSheet addChild:hero];
        [self addChild:hero.pathToFollow z:-1];
        
        CCAnimation *moveAnimation = [CCAnimation animationWithName:@"heroMove" delay:0.3f];
        
        for (int x = 0; x < 2; x++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:heroSpriteSheet.texture
                                                              rect:CGRectMake(x * 32, 0, 32, 32)
                                                            offset:ccp(0,0)];
            [moveAnimation addFrame:frame];
        }
        
        CCAnimate *moveAction = [CCAnimate actionWithAnimation:moveAnimation];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:moveAction];
        [hero runAction:repeat];
        
        [hero setPosition:CGPointMake(screenSize.width / 2, screenSize.height / 2)];
    }
    
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	
}

-(void) tick: (ccTime) dt
{
    [hero update:dt];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Check the touch began in the hero sprite
    CGRect spriteBounds = CGRectMake(hero.position.x - hero.contentSize.width / 2,
                                     hero.position.y - hero.contentSize.height / 2,
                                     hero.contentSize.width,
                                     hero.contentSize.height);
    
    if (location.x >= spriteBounds.origin.x
        && location.x <= spriteBounds.origin.x + spriteBounds.size.width
        && location.y >= spriteBounds.origin.y &&
        location.y <= spriteBounds.origin.y + spriteBounds.size.height) {
        
        location = hero.position;
        [hero stopMovement];
        [hero.pathToFollow clear];
        [hero.pathToFollow startAcceptingInput];
        [hero.pathToFollow processPoint:location];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (hero.pathToFollow.acceptingInput) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        [hero.pathToFollow processPoint:location];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (hero.pathToFollow.acceptingInput) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        [hero.pathToFollow processPoint:location];
        [hero.pathToFollow stopAcceptingInput];
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{	
	delete m_debugDraw;
    
    [heroSpriteSheet release];
    [hero release];

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
