//
//  IICaptain.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IICaptain.h"
#import "IIStartOnNodeGestureFilter.h"
#import "IIFollowPathBehavior.h"
#import "IISmoothPath.h"

@implementation IICaptain

@synthesize speed;
@synthesize pathToFollow;

- (void) handleDragGesture: (UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView: sender.view];
    point = [[CCDirector sharedDirector] convertToGL:point];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            point = self.position;
            [pathToFollow clear];
            [pathToFollow processPoint:point];
            break;
        case UIGestureRecognizerStateChanged:
            
            [pathToFollow processPoint:point];
            
            break;
        default:
            break;
    }
}

- (void) setManager:(IIGestureManager *) theManager {
    manager = theManager;
    IIStartOnNodeGestureFilter *filter = [[[IIStartOnNodeGestureFilter alloc] initWithNode: self widthTolerance: 16 andHeightTolerance: 0] autorelease];
    [manager addTarget: self action: @selector(handleDragGesture:) toRecognizer: @"singleDragGesture" withFilter: filter];
    [manager retain];
}

- (id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager {
    if ((self = [super initWithTexture: texture rect: rect])) {
        [self setManager: theManager];
        pathToFollow = [[IISmoothPath alloc] initWithMinimumLineLength: 16];
        behaviors = [[NSMutableArray alloc] initWithCapacity:5];
        //currentLineBeingFollowed = nil;
        speed = 32;
        
        // Change this later. The path could be now outside of this object and respond to the touches instead.
        [behaviors addObject:[[[IIFollowPathBehavior alloc] initWithSmoothPath: pathToFollow] autorelease]];
    }
    
    return self;
}

- (void) update: (ccTime) timeElapsedSinceLastFrame {
    
    for (id<IIBehaviorProtocol> behavior in behaviors) {
        [behavior updateTarget: self timeSinceLastFrame: timeElapsedSinceLastFrame];
    }
}

- (void) addPathToNode: (CCNode *) theNode {
    [theNode addChild: pathToFollow];
}

- (void) addBehavior:(id <IIBehaviorProtocol>) behaviorToAdd {
    [behaviors addObject: behaviorToAdd];
}

+(id) spriteWithTexture:(CCTexture2D*) texture rect:(CGRect) rect andManager: (IIGestureManager *) theManager
{
	IICaptain *me = [[[self alloc] initWithTexture:texture rect:rect andManager: theManager] autorelease];
    me.manager = theManager;
    
    return me;
}

-(void) dealloc {
    [behaviors release];
    [manager release];
    [pathToFollow release];
    [super dealloc];
}

@end
