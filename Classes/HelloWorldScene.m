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
#import "IIMoveStraightBehavior.h"
#import "IIFollowPathBehavior.h"
#import "IIWeapon.h"
#import "IIFireWeaponByGestureBehavior.h"
#import "IISmoothPath.h"
#import "IICaptain.h"

// HelloWorld implementation
@implementation HelloWorld

@synthesize hero;

- (id) initWithGestureManaget: (IIGestureManager *) theGestureManager {
    if ((self = [super initWithGestureManaget: theGestureManager]) != nil) {
        
        heroSpriteSheet = [CCSpriteSheet spriteSheetWithFile: @"bigship.png"];
        CCSprite *heroSprite = [CCSprite spriteWithTexture:heroSpriteSheet.texture];
        [heroSpriteSheet addChild: heroSprite];
        
        IISmoothPath *pathToFollow = [[IISmoothPath alloc] initWithMinimumLineLength: 16];
        
        // 2.7925 rad =~ 160 degrees
        pathToFollow.angleThreshold = 2.7925;
        // 1.04719755 rad =~ 60 degrees
        pathToFollow.minimumAllowedAngle = 1.04719755;
        pathToFollow.maximumPathLength = 800;
        hero = [[IICaptain alloc] initWithNode: heroSprite andPath: pathToFollow];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        hero.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        
        IIFollowPathBehavior *followPath = [[[IIFollowPathBehavior alloc] initWithUpdatablePath: pathToFollow
                                                                                         onNode: heroSprite
                                                                              andGestureManager: gestureManager]
                                            autorelease];
        
        IIMoveStraightBehavior *moveStraight = [[[IIMoveStraightBehavior alloc] init] autorelease];
        [moveStraight requiresBehaviorToFail: followPath];
        
        IIWeapon *cannon = [[[IIWeapon alloc] initWithNode: heroSprite andScene: self] autorelease];
        IIFireWeaponByGestureBehavior *fireWeaponByGestureBehavior = [[[IIFireWeaponByGestureBehavior alloc]
                                                                       initWithManager: gestureManager
                                                                               gesture: @"singleTapGesture"
                                                                             andWeapon: cannon]
                                                                      autorelease];
		
		
		
		//Setup Map
		sea = [CCTMXTiledMap tiledMapWithTMXFile:@"sea.tmx"];
		
		CCTMXObjectGroup *objects = [sea objectGroupNamed:@"GameObjects"];
        NSAssert(objects != nil, @"'GameObjects' object group not found");
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"ShipPosition"];        
        NSAssert(spawnPoint != nil, @"ShipPosition object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
		
		//Put the ship in the center of the map. 
		hero.position = ccp(x, y);
        
        [hero addBehavior: followPath];
        [hero addBehavior: moveStraight];
        [hero addBehavior: fireWeaponByGestureBehavior];
        [self addGameObject: hero];
        
        [gameLayer addChild: pathToFollow];
        [gameLayer addChild: heroSpriteSheet]; 
		[gameLayer addChild: sea z:-1];
    }
    
    return self;
}

- (void) afterUpdate: (ccTime) timeElapsedSinceLastFrame {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGPoint screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    
    CGPoint scrrenCenterOnLayer = [gameLayer convertToNodeSpace: screenCenter];
    
    CGPoint heroDistanceToScreenCenter = ccpSub(hero.position, scrrenCenterOnLayer);
    
    gameLayer.position = ccpSub(gameLayer.position, heroDistanceToScreenCenter);
}

- (void) dealloc {	
    [heroSpriteSheet release];
    [hero release];
	[super dealloc];
}

@end
