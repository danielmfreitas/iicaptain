//
//  IICaptain.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-21.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IICaptain.h"
#import "IIStartOnNodeGestureFilter.h"
#import "IIMoveStraightBehavior.h"
#import "IIFollowPathBehavior.h"
#import "IISmoothPath.h"

@implementation IICaptain

@synthesize pathToFollow;
@synthesize speed;

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
    IIStartOnNodeGestureFilter *filter = [[[IIStartOnNodeGestureFilter alloc]
                                           initWithNode: node widthTolerance: 16 andHeightTolerance: 0] autorelease];
    [manager addTarget: self action: @selector(handleDragGesture:)
          toRecognizer: @"singleDragGesture" withFilter: filter];
    [manager retain];
}

- (id) initWithNode: (CCNode *) aNode andManager: (IIGestureManager *) theManager {
    if ((self = [super initWithNode: aNode])) {
        [self setManager: theManager];
        pathToFollow = [[IISmoothPath alloc] initWithMinimumLineLength: 16];
        behaviors = [[NSMutableArray alloc] initWithCapacity:5];
        speed = 32;
        
        // TODO Change this later. The path could be now outside of this object and respond to the touches instead.
        IIFollowPathBehavior *followPath = [[[IIFollowPathBehavior alloc] initWithSmoothPath:pathToFollow] autorelease];
        IIMoveStraightBehavior *moveStraight = [[[IIMoveStraightBehavior alloc] init] autorelease];
        
        [moveStraight requiresBehaviorToFail: followPath];
        
        [behaviors addObject:followPath];
        [behaviors addObject:moveStraight];
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

-(void) dealloc {
    [behaviors release];
    [manager release];
    [pathToFollow release];
    [super dealloc];
}

@end
