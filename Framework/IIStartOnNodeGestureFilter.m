//
//  IIStartOnNodeGestureFilter.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-29.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIStartOnNodeGestureFilter.h"
#import "HelloWorldScene.h"
#import "IICaptain.h"
#import <cocos2d/cocos2d.h>

@implementation IIStartOnNodeGestureFilter
- (id) initWithNode: (CCNode *) node {
    
    if ((self = [super init])) {
        targetNode = node;
        [targetNode retain];
        shouldAcceptInput = NO;
    }
    
    return self;
}

- (id) initWithNode: (CCNode *) node widthTolerance: (NSInteger) theWTolerance andHeightTolerance: (NSInteger) theHTolerance {
    
    if ((self = [self initWithNode: node])) {
        widthTolerance = theWTolerance;
        heightTolerance = theHTolerance;
    }
    
    return self;
}

- (BOOL) acceptsEvent: (UIGestureRecognizer *) recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint point = [recognizer locationInView: recognizer.view];
            point = [[CCDirector sharedDirector] convertToGL:point];
            //TODO Provide a better way to access the game layer.
            point = [((HelloWorld *)[[CCDirector sharedDirector] runningScene]).gameLayer convertToNodeSpace: point];
            
            CGRect spriteBounds = CGRectMake(targetNode.position.x - (targetNode.contentSize.width / 2 + widthTolerance),
                                             targetNode.position.y - (targetNode.contentSize.height / 2 + heightTolerance),
                                             targetNode.contentSize.width + widthTolerance,
                                             targetNode.contentSize.height + heightTolerance);
            
            if (point.x >= spriteBounds.origin.x
                && point.x <= spriteBounds.origin.x + spriteBounds.size.width
                && point.y >= spriteBounds.origin.y &&
                point.y <= spriteBounds.origin.y + spriteBounds.size.height) {
                
                shouldAcceptInput = YES;
                return YES;
            }
            
            shouldAcceptInput = NO;
            return NO;
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            shouldAcceptInput = NO;
            return YES;
            break;
        }
        default:
            return shouldAcceptInput;
            break;
    }
}

- (void) dealloc {
    [targetNode release];
    [super dealloc];
}

@end
