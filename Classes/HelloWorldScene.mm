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
        
        float x1, y1, x2, y2;
        
        x1 = 50;
        y1 = 150;
        x2 = cos(M_PI / 2) * 16;
        y2 = sin(M_PI / 2) * 16;
        
        line = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line.endPoint.x;
        y1 = line.endPoint.y;
        x2 = cos(M_PI / 2) * 16;
        y2 = sin(M_PI / 2) * 16;
        
        line2 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line2.endPoint.x;
        y1 = line2.endPoint.y;
        x2 = cos(M_PI / 6) * 64;
        y2 = sin(M_PI / 6) * 64;
        
        line3 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line3.endPoint.x;
        y1 = line3.endPoint.y;
        x2 = cos(0) * 64;
        y2 = sin(0) * 64;
        
        line4 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line4.endPoint.x;
        y1 = line4.endPoint.y;
        x2 = cos(5 * M_PI / 3) * 64;
        y2 = sin(5 * M_PI / 3) * 64;
        
        line5 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line5.endPoint.x;
        y1 = line5.endPoint.y;
        x2 = cos(11 * M_PI / 6) * 96;
        y2 = sin(11 * M_PI / 6) * 96;
        
        line6 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line6.endPoint.x;
        y1 = line6.endPoint.y;
        x2 = cos(5 * M_PI / 4) * 48;
        y2 = sin(5 * M_PI / 4) * 48;
        
        line7 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line7.endPoint.x;
        y1 = line7.endPoint.y;
        x2 = cos(7 * M_PI / 6) * 128;
        y2 = sin(7 * M_PI / 6) * 128;
        
        line8 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line8.endPoint.x;
        y1 = line8.endPoint.y;
        x2 = cos(2 * M_PI / 3) * 64;
        y2 = sin(2 * M_PI / 3) * 64;
        
        line9 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        x1 = line9.endPoint.x;
        y1 = line9.endPoint.y;
        x2 = cos(3 * M_PI / 2) * 32;
        y2 = sin(3 * M_PI / 2) * 32;
        
        line10 = [IILine2D lineFromOrigin:CGPointMake(x1, y1) toEnd:CGPointMake(x1 + x2, y1 + y2) withTextureFile:@"path_texture.png"];
        
        [self addChild:line];
        [self addChild:line2];
        [self addChild:line3];
        [self addChild:line4];
        [self addChild:line5];
        [self addChild:line6];
        [self addChild:line7];
        [self addChild:line8];
        [self addChild:line9];
        [self addChild:line10];
        
        IILine2D *upLine = [IILine2D lineFromOrigin:CGPointMake(200, 210) toEnd:CGPointMake(200, 230) withTextureFile:@"path_texture_debug.png"];
        upLine.xTextureTranslate = 2;
        upLine.yTextureTranslate = 2;
        [self addChild:upLine];
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
    static int count = 0;
    static int offset = 0;
    count++;
    
    
    // Test sprite animation by changing texture position on 
    if (count % 2 == 0) {
        offset++;
        // TODO: Make this part of the sprite implementation.
        line.xTextureTranslate = offset % 8;
        line2.xTextureTranslate = offset % 8;
        
        line3.xTextureTranslate = (offset / 2) % 8;
        line3.yTextureTranslate = offset % 16;
        
        line4.xTextureTranslate = (offset / 2) % 8;
        line4.yTextureTranslate = offset % 16;
        
        line5.yTextureTranslate = offset % 16;
        line6.yTextureTranslate = offset % 16;
        line7.yTextureTranslate = offset % 16;
        line8.yTextureTranslate = offset % 16;
        line9.yTextureTranslate = offset % 16;
        line10.yTextureTranslate = offset % 16;
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"ToucheS began");
    
    for(id obj in touches) {                
        NSLog(@"Multi*** %@", obj);
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"ToucheS moved");
    
    for(id obj in touches) {                
        NSLog(@"Multi*** %@", obj);
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"ToucheS ended");
    
    for(id obj in touches) {                
        NSLog(@"Multi*** %@", obj);
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
