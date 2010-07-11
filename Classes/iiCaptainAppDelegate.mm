//
//  iiCaptainAppDelegate.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-18.
//  Copyright Eye Eye 2010. All rights reserved.
//

#import "iiCaptainAppDelegate.h"
#import "cocos2d.h"
#import "HelloWorldScene.h"
#import "IIGestureManager.h"

@implementation iiCaptainAppDelegate

@synthesize window;

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    NSLog(@"Got dragging");
}

- (void)handleDrag2:(UIPanGestureRecognizer *)sender {
    NSLog(@"Got dragging2");
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
    //[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
    // Creates gesture manager
	IIGestureManager *manager = [IIGestureManager gestureManagerWithTargetView:window];
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
	
	[[CCDirector sharedDirector] runWithScene: [HelloWorld sceneAndManager: manager]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
