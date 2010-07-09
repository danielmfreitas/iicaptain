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
#import "IIFollowPathBehavior.h"

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

@synthesize manager;

+(id) sceneAndManager: (IIGestureManager *) theManager;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [[HelloWorld alloc] initWithManager: theManager];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

// initialize your instance here
-(id) initWithManager: (IIGestureManager *) theManager
{
	if( (self=[super initWithColor:ccc4(0, 0, 128, 255)])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		[self schedule: @selector(tick:)];
        
        manager = theManager;
        [manager retain];
        
        heroSpriteSheet = [CCSpriteSheet spriteSheetWithFile: @"bigship.png"];
        CCSprite *heroSprite = [CCSprite spriteWithTexture: heroSpriteSheet.texture rect: CGRectMake(0, 0, 32, 64)];
        [heroSprite autorelease];
        hero = [[IICaptain alloc] initWithNode:heroSprite andManager: theManager];
        [hero addPathToNode: self];
        
        [self addChild:heroSpriteSheet z:1]; 
        // TODO Figure out a way to add pathToFollow automatically.
        // [self addChild: hero.pathToFollow z: -1];
        [heroSpriteSheet addChild:heroSprite];
        [hero moveByX: screenSize.width / 2 andY: screenSize.height / 2];
    }
    
	return self;
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	
}

-(void) tick: (ccTime) dt
{
    [hero update:dt];
}

//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:[touch view]];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    // Check the touch began in the hero sprite
//    CGRect spriteBounds = CGRectMake(hero.position.x - hero.contentSize.width / 2,
//                                     hero.position.y - hero.contentSize.height / 2,
//                                     hero.contentSize.width,
//                                     hero.contentSize.height);
//    
//    if (location.x >= spriteBounds.origin.x
//        && location.x <= spriteBounds.origin.x + spriteBounds.size.width
//        && location.y >= spriteBounds.origin.y &&
//        location.y <= spriteBounds.origin.y + spriteBounds.size.height) {
//        
//        location = hero.position;
//        [hero stopMovement];
//        [hero.pathToFollow clear];
//        [hero.pathToFollow startAcceptingInput];
//        [hero.pathToFollow processPoint:location];
//    }
//}
//
//- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (hero.pathToFollow.acceptingInput) {
//        UITouch *touch = [touches anyObject];
//        CGPoint location = [touch locationInView:[touch view]];
//        location = [[CCDirector sharedDirector] convertToGL:location];
//        [hero.pathToFollow processPoint:location];
//    }
//}
//
//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (hero.pathToFollow.acceptingInput) {
//        UITouch *touch = [touches anyObject];
//        CGPoint location = [touch locationInView:[touch view]];
//        location = [[CCDirector sharedDirector] convertToGL:location];
//        [hero.pathToFollow processPoint:location];
//        [hero.pathToFollow stopAcceptingInput];
//    }
//}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{	
	delete m_debugDraw;
    
    [manager release];

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
